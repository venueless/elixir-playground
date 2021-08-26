defmodule Venueless.Db.RoomEvent do
	use Ecto.Schema
	import Ecto.Query
	alias __MODULE__
	alias Venueless.Db.Repo
	alias Venueless.Db.Room
	alias Venueless.Db.User

	@primary_key {:id, Ecto.ULID, autogenerate: true}
	@foreign_key_type Ecto.ULID

	@derive {Jason.Encoder, only: [:id, :room_id, :sender_id, :timestamp, :type, :content]}

	schema "room_events" do
		belongs_to :room, Room, type: Ecto.UUID
		belongs_to :sender, User, type: Ecto.UUID
		# field :timestamp, :utc_datetime_usec, autogenerate: [DateTime, :utc_now, []]
		field :type, :string
		field :content, :map
		timestamps(inserted_at: :timestamp, updated_at: false, type: :utc_datetime_usec)
	end

	def list_after_id(before_id, limit) do
		(from event in RoomEvent,
		where: event.id < ^before_id,
		limit: ^limit,
		order_by: [desc: event.id]) # we need to query in descending order to get the latest events first before the limit hits
		|> Repo.all()
		|> Enum.reverse() # deliver events in ascending order
	end
end
