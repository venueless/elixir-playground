defmodule Venueless.World do
	use GenServer, restart: :transient
	require Logger

	defp via_tuple(world_id),
		do: {:via, Registry, {Venueless.WorldRegistry, world_id}}

	def start_link(config) do
		GenServer.start_link(__MODULE__, config, name: via_tuple(config["id"]))
	end

	def log_state(world_id) do
		world_id |> via_tuple() |> GenServer.call(:log_state)
	end

	def get_state(world_pid) when is_pid(world_pid) do
		GenServer.call(world_pid, :get_state)
	end

	def get_state(world_id) do
		world_id |> via_tuple() |> GenServer.call(:get_state)
	end

	def connect(world_id, user_id) do
		world_id |> via_tuple() |> GenServer.call({:connect, user_id})
	end

	def stop(world_id, stop_reason) do
		# Given the :transient option in the child spec, the GenServer will restart
		# if any reason other than `:normal` is given.
		world_id |> via_tuple() |> GenServer.stop(stop_reason)
	end

	## GenServer Callbacks

	@impl true
	def init(config) do
		Logger.info("Starting world #{inspect(config)}")
		children = [
			{Venueless.RoomSupervisor, []}
		]
		{:ok, room_supervisor_pid} = Supervisor.start_link(children, [strategy: :one_for_one])
		{:ok, %{
			:config => config,
			:room_supervisor => room_supervisor_pid,
		}}
	end

	@impl true
	def handle_call(:log_state, _from, state) do
		{:reply, "State: #{inspect(state)}", state}
	end

	@impl true
	def handle_call(:get_state, _from, state) do
		{:reply, %{
			:world => state.config,
			:rooms => state.config["rooms"]
		}, state}
	end

	@impl true
	def handle_call({:connect, user_id}, _from, state) do
		# new_state =
		# 	Map.update!(state, :players, fn existing_players ->
		# 		[new_player | existing_players]
		# 	end)

		{:reply, {state.config}, state}
	end
end
