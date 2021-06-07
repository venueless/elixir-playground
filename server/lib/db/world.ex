defmodule Venueless.Db.World do
	use Ecto.Schema
	alias Venueless.Db.User

	@primary_key {:id, :string, autogenerate: false}
	@foreign_key_type :string

	schema "worlds" do
		field :title, :string
		field :config, :map
		has_many :users, User
	end
end
