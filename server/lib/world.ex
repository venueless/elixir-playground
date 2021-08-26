defmodule Venueless.World do
	use GenServer, restart: :transient
	require Logger

	alias Venueless.Db

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

	def get_users(world_id, user_ids) do
		world_id |> via_tuple() |> GenServer.call({:get_users, user_ids})
	end

	def connect_user(world_id, login_info) do
		world_id |> via_tuple() |> GenServer.call({:connect_user, login_info})
	end

	# def connect(world_id, user_id) do
	# 	world_id |> via_tuple() |> GenServer.call({:connect, user_id})
	# end

	def stop(world_id, stop_reason) do
		# Given the :transient option in the child spec, the GenServer will restart
		# if any reason other than `:normal` is given.
		world_id |> via_tuple() |> GenServer.stop(stop_reason)
	end

	## GenServer Callbacks

	@impl true
	def init(config) do
		Logger.info("Starting world #{inspect(config)}")
		{:ok, room_supervisor_pid} = Venueless.RoomSupervisor.start_link([])
		world = Db.World.get_with_rooms_and_users(config["id"])
		# boot rooms
		Enum.each(world.rooms, fn room ->
			{:ok, pid} = DynamicSupervisor.start_child(room_supervisor_pid, {Venueless.Room, room})
		end)
		{:ok, %{
			:world => world,
			:users_by_id => Map.new(world.users, fn user -> {user.id, user} end),
			:users_by_client_id => Map.new(world.users, fn user -> {user.client_id, user} end),
			# don't rely on world.users after this point
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
			:world => %{
				title: state.world.title
				# TODO config fields
			},
			:rooms => Enum.map(state.world.rooms, fn room -> Map.put(room, :permissions, ["room:chat.join", "room:chat.send"]) end)
		}, state}
	end

	@impl true
	def handle_call({:get_users, user_ids}, _from, state) do
		{:reply, {:ok, Enum.map(user_ids, fn id -> state.users_by_id[id] end)}, state}
	end

	@impl true
	def handle_call({:connect_user, login_info}, _from, state) do
		{state, user} = case state.users_by_client_id[login_info.client_id] do
			nil ->
				user = Db.Repo.insert!(%Db.User{
					world_id: state.world.id,
					client_id: login_info.client_id
				})
				state = put_in(state, [:users_by_id, user.id], user)
				state = put_in(state, [:users_by_client_id, user.client_id], user)
				{state, user}
			user -> {state, user}
		end
		{:reply, {:ok, user}, state}
	end

	# @impl true
	# def handle_call({:connect, user_id}, _from, state) do
	# 	# new_state =
	# 	# 	Map.update!(state, :players, fn existing_players ->
	# 	# 		[new_player | existing_players]
	# 	# 	end)
	#
	# 	{:reply, {state.config}, state}
	# end
end
