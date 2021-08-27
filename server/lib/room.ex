defmodule Venueless.Room do
	use GenServer
	require Logger

	alias Venueless.Db

	defp via_tuple(room) do
		{:via, Registry, {Venueless.RoomRegistry, room.id, %{
			world: room.world_id
		}}}
	end

	def rpc_call(room_pid, action, payload, user, sender_pid) do
		GenServer.call(room_pid, {:rpc_call, action, payload, user, sender_pid})
	end

	def start_link(room) do
		GenServer.start_link(__MODULE__, room, name: via_tuple(room))
	end

	@impl true
	def init(room) do
		Logger.info("Starting room #{inspect(room)}")
		{:ok, %{
			room: room,
			subscribed_clients: %{},
			# client_monitors: %{}
		}}
	end

	@impl true
	def handle_call({:rpc_call, action, payload, user, sender_pid}, _from, state) do
		handle_rpc_call(action, payload, user, sender_pid, state)
	end

	defp handle_rpc_call("subscribe", _payload, _user, sender_pid, state) do
		ref = Process.monitor(sender_pid)
		state = put_in(state, [:subscribed_clients, sender_pid], %{ref: ref})
		# state = put_in(state, [:client_monitors, ref], client_pid)
		# generate an ULID from which the client can start fetching past messages
		{:reply, {:ok, %{subscribed_at_id: Ecto.ULID.generate()}}, state}
	end

	defp handle_rpc_call("send", payload, user, sender_pid, state) do
		event = Db.Repo.insert!(%Db.RoomEvent{
			room: state.room,
			sender: user,
			type: payload["type"],
			content: payload["content"]
		})
		Logger.info("saved room event #{inspect(event)}")
		broadcast_to_others(Jason.encode!(["room.event", event]), sender_pid, state)
		{:reply, {:ok, event}, state}
	end

	defp handle_rpc_call("fetch", payload, _user, _sender_pid, state) do
		events = Db.RoomEvent.list_after_id(payload["before_id"], payload["count"])
		{:reply, {:ok, events}, state}
	end

	defp handle_rpc_call(action, payload, _from, _sender_pid, state) do
		Logger.error("unmatched call action room.#{action} #{inspect(payload)}")
		{:reply, {:error, "unknown action"}, state}
	end

	@impl true
	# handle died socket clients and remove from maps
	def handle_info({:DOWN, _ref, :process, client_pid, _}, state) do
		# client_pid = state.client_monitors[ref]
		# state = pop_in(state, [:client_monitors, ref])
		{_, state} = pop_in(state, [:subscribed_clients, client_pid])
		Logger.info("Disconnected client from room #{inspect(state.room.id)}")
		{:noreply, state}
	end

	defp broadcast_to_others(message, sender_pid, state) do
		Enum.each(state.subscribed_clients, fn {pid, _} ->
			if pid != sender_pid do
				Process.send(pid, message, [])
			end
		end)
	end
end
