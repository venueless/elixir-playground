defmodule Venueless.Db.User do
	use Venueless.Schema
	import Ecto.Changeset
	alias Venueless.Db.World

	schema "users" do
		field :client_id, :string
		field :token_id, :string
		field :profile, :map, default: %{}
		belongs_to :world, World, type: :string
	end

	def update_changeset(user, params) do
		user
		|> cast(params, [:profile])
	end

	def serialize_public(user) do
		Map.take(user, [:id, :profile])
	end
end
