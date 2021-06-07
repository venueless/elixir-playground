defmodule Venueless.Db.User do
	use Venueless.Schema
	alias Venueless.Db.World

	schema "users" do
		field :client_id, :string
		field :token_id, :string
		field :profile, :map, default: %{}
		belongs_to :world, World, type: :string
	end
end
