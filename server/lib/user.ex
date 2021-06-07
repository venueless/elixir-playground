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
end
