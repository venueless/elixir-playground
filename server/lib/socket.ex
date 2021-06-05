defmodule Venueless.Socket do
	@behaviour :cowboy_websocket
	require Logger

	alias Venueless.World
	alias Venueless.User

	def init(request, _state) do
		state = %{world: request.bindings.world}
		Logger.info("received connection for world #{request.bindings.world}")
		{:cowboy_websocket, request, state}
	end

	def websocket_init(state) do
		{:ok, state}
	end

	def websocket_handle({:text, json}, state) do
		payload = Jason.decode!(json)
		Logger.info("got message: #{inspect(payload)}")
		handle_message(state, payload)
		# {:ok, state}
		# {:reply, {:text, message}, state}
	end

	def websocket_info(info, state) do
		{:reply, {:text, info}, state}
	end

	defp handle_message(state, ["authenticate", %{"client_id" => client_id}]) do
		Logger.info('authenticating with client id: #{client_id}')
		{:ok, user_pid} = User.connect(%{:client_id => client_id})
		Logger.info(inspect(user_pid))
		{:ok, Map.put(state, :user_pid, user_pid)}
	end

	defp handle_message(state, ["authenticate", %{"token" => token}]) do
		Logger.info('authenticating with token: #{token}')
		{:ok, state}
	end

	defp handle_message(state, message) do
		Logger.info('UNHANDLED MESSAGE')
		{:ok, state}
	end
end
