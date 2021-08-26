defmodule Venueless.Db.Room do
	use Venueless.Schema
	import Ecto.Changeset
	alias Venueless.Db.World

	@derive {Jason.Encoder, only: [:id, :name, :description, :modules, :sorting_priority, :pretalx_id, :force_join, :permissions]}

	schema "rooms" do
		belongs_to :world, World, type: :string
		field :name, :string
		field :description, :string
		field :modules, {:array, :map}
		field :sorting_priority, :integer
		field :pretalx_id, :integer
		field :force_join, :boolean
	end
end
