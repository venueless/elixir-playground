defmodule Venueless.Socket do
	@behaviour :cowboy_websocket
	require Logger

	alias Venueless.World
	alias Venueless.User

	def init(request, _state) do
		{:cowboy_websocket, request, request.bindings.world}
	end

	def websocket_init(world_id) do
		Logger.info("received connection for world #{world_id}")
		# TODO load world if it's not online
		[{world, _}] = Registry.lookup(Venueless.WorldRegistry, world_id)
		state = %{world: world}
		{:ok, state}
	end

	def websocket_handle({:text, json}, state) do
		payload = Jason.decode!(json)
		Logger.info("got message: #{inspect(payload)}")
		result = handle_message(state, payload)
		Logger.info(inspect(result))
		case result do
			{:reply, reply, state} -> {:reply, {:text, Jason.encode!(reply)}, state}
			{:ok, state} -> {:ok, state}
			_ -> {:ok, state}
		end
	end

	def websocket_info(info, state) do
		{:reply, {:text, info}, state}
	end

	defp handle_message(state, ["authenticate", login_info]) do
		{:ok, user_pid} = case login_info do
			%{"client_id" => client_id} ->
				Logger.info('authenticating with client id: #{client_id}')
				User.connect(%{:client_id => client_id})
			%{"token" => token} ->
				Logger.info('authenticating with token: #{token}')
		end
		state = Map.put(state, :user_pid, user_pid)
		{:reply, ["authenticated", %{
			"world.config" => World.get_state(state.world),
			"user.config" => %{"id" => 3, "profile" => %{}}
		}], state}
	end

	defp handle_message(state, ["ping", timestamp]) do
		{:reply, ["pong", timestamp], state}
	end

	defp handle_message(state, message) do
		Logger.info('UNHANDLED MESSAGE')
		{:ok, state}
	end
end
