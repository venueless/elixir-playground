defmodule Venueless.User do
	use GenServer
	require Logger

	alias Venueless.Db

	defp via_tuple(user),
		do: {:via, Registry, {Venueless.UserRegistry, user.id, %{
			id: user.id,
			client_id: user.client_id
		}}}

	def connect(world_id, login_info) do
		user_list = case login_info do
			# generated this via :ets.fun2ms(fn {_, _, user} when user.client_id == XXX -> user end)
			%{client_id: client_id} -> Registry.select(Venueless.UserRegistry, [{{:_, :"$1", :"$2"}, [{:==, {:map_get, :client_id, :"$2"}, client_id}], [:"$1"]}])
		end

		case user_list do
			[user_pid] ->
				Logger.info("user exists #{inspect(user_pid)}")
				{:ok, user_pid}
			_ ->
				Logger.info("user not registered, creating")
				user = case Db.Repo.get_by(Db.User, [
					world_id: world_id,
					client_id: login_info.client_id
				]) do
					nil ->
						Db.Repo.insert!(%Db.User{
							world_id: world_id,
							client_id: login_info.client_id
						})
					user -> user
				end
				{:ok, pid} = DynamicSupervisor.start_child(Venueless.UserSupervisor, {Venueless.User, user})
				{:ok, pid}
		end
	end

	def get_user_data(user_pid) when is_pid(user_pid) do
		GenServer.call(user_pid, :get_user_data)
	end

	def rpc_call(user_pid, action, payload) do
		GenServer.call(user_pid, {:rpc_call, action, payload})
	end

	# called by UserSupervisor when running start_child
	# actually starts a new process (with init) and hooks up to supervisor and registry
	def start_link(user) do
		GenServer.start_link(__MODULE__, user, name: via_tuple(user))
	end

	@impl true
	def init(user) do
		Logger.info("Starting user #{inspect(user)}")
		{:ok, %{
			user: user,
		}}
	end

	@impl true
	def handle_call(:get_user_data, _from, state) do
		{:reply, %{
			:id => state.user.id,
			:profile => state.user.profile
		}, state}
	end

	@impl true
	def handle_call({:rpc_call, action, payload}, _from, state) do
		handle_rpc_call(action, payload, state)
	end

	defp handle_rpc_call("update", update, state) do
		changeset = Db.User.update_changeset(state.user, update)
		case Db.Repo.update(changeset) do
			{:ok, user} ->
				state = Map.put(state, :user, user)
				{:reply, {:ok, Db.User.serialize_public(user)}, state }
			{:error, error} -> {:reply, {:error, error}, state}
		end

	end
end
