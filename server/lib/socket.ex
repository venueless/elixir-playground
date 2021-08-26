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
		state = %{
			world_id: world_id,
			world: world
		}
		{:ok, state}
	end

	def websocket_handle({:text, json}, state) do
		message = Jason.decode!(json)
		Logger.info("got message: #{inspect(message)}")
		result = case message do
			[action, seq, payload] when is_integer(seq) ->
				# TODO exception handling?
				# pipe everything through user
				response = User.rpc_call(state.user_pid, action, payload)
				case response do
					{:ok, response} -> {:reply, ["success", seq, response], state}
					{:ok} -> {:reply, ["success", seq], state}
					# TODO handle long running tasks somehow
					{:error, error} -> {:reply, ["error", seq, error], state}
				end
			message -> handle_message(message, state)
		end
		Logger.info(inspect(result))
		case result do
			{:reply, reply, state} -> {:reply, {:text, Jason.encode!(reply)}, state}
			{:ok, state} -> {:ok, state}
			_ -> {:ok, state}
		end
	end

	def websocket_info(message, state) do
		Logger.info("sending broadcast message #{inspect(message)}")
		{[{:text, Jason.encode!(message)}], state}
	end

	# GENERIC MESSAGE HANDLERS

	defp handle_message(["authenticate", login_info], state) do
		{:ok, user_pid} = case login_info do
			%{"client_id" => client_id} ->
				Logger.info('authenticating with client id: #{client_id}')
				User.connect(state.world_id, %{:client_id => client_id})
			%{"token" => token} ->
				Logger.info('authenticating with token: #{token}')
		end
		state = Map.put(state, :user_pid, user_pid)
		{:reply, ["authenticated", %{
			"world.config" => World.get_state(state.world),
			"user.config" => User.get_user_data(user_pid)
		}], state}
	end

	defp handle_message(["ping", timestamp], state) do
		{:reply, ["pong", timestamp], state}
	end

	defp handle_message(state, message) do
		Logger.info('UNHANDLED MESSAGE')
		{:ok, state}
	end
end
