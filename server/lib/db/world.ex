defmodule Venueless.Db.World do
	use Ecto.Schema
	import Ecto.Query
	alias __MODULE__
	alias Venueless.Db.Repo
	alias Venueless.Db.User
	alias Venueless.Db.Room

	@primary_key {:id, :string, autogenerate: false}
	@foreign_key_type :string

	schema "worlds" do
		field :title, :string
		field :config, :map
		has_many :rooms, Room
		has_many :users, User
	end

	def get_with_rooms_and_users (id) do
		(from w in World,
		left_join: r in assoc(w, :rooms),
		left_join: u in assoc(w, :users),
		preload: [rooms: r, users: u])
		|> Repo.get(id)
	end
end
