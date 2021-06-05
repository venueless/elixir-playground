defmodule Venueless.User do
	use GenServer
	require Logger

	defp via_tuple(user_info),
		do: {:via, Registry, {Venueless.UserRegistry, user_info.id, user_info}}

	def connect(login_info) do
		Logger.info(login_info)
		user_list = case login_info do
			# generated this via :ets.fun2ms(fn {_, _, user} when user.client_id == XXX -> user end)
			%{:client_id => client_id} -> Registry.select(Venueless.UserRegistry, [{{:_, :"$1", :"$2"}, [{:==, {:map_get, :client_id, :"$2"}, client_id}], [:"$1"]}])
		end

		if length(user_list) > 0 do
			Logger.info("user exists #{inspect(user_list)}")
			{:ok, List.first(user_list)}
		else
			Logger.info("user not registered, creating")
			# TODO go ask the db for user data here
			user_info = %{
				:id => Ecto.UUID.generate(),
				:client_id => login_info.client_id
			}
			{:ok, pid} = DynamicSupervisor.start_child(Venueless.UserSupervisor, {Venueless.User, user_info})
			{:ok, pid}
		end


	end

	# called by UserSupervisor when running start_child
	# actually starts a new process and hooks up to supervisor and registry
	def start_link(user_info) do
		GenServer.start_link(__MODULE__, user_info, name: via_tuple(user_info))
	end

	@impl true
	def init(user_info) do
		Logger.info("Starting user #{inspect(user_info)}")
		{:ok, %{
			:user_info => user_info,
		}}
	end
end
