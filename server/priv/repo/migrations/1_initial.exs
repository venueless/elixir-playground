defmodule Venueless.Db.Repo.Migrations.Initial do
	use Ecto.Migration

	def change do
		create table("worlds", primary_key: false) do
			add :id, :string, primary_key: true
			add :title, :string, null: false
			add :config, :map, null: false
			# roles
			# trait_grants
			# domain
			# locale
			# timezone
			# feature_flags
		end

		create table("users", primary_key: false) do
			add :id, :uuid, primary_key: true
			add :world_id, references("worlds", type: :string), null: false
			add :client_id, :string
			add :token_id, :string
			add :profile, :map, null: false
			# moderation_state
			# show_publicly
			# traits
			# blocked_users
			# last_login
		end
		create index("users", [:world_id, :client_id], unique: true)
		create index("users", [:world_id, :token_id], unique: true)

		create table("rooms", primary_key: false) do
			add :id, :uuid, primary_key: true
			add :world_id, references("worlds", type: :string), null: false
			add :name, :string, null: false
			add :description, :text
			add :modules, :map
			add :sorting_priority, :integer
			add :pretalx_id, :integer
			add :force_join, :boolean
			# trait_grants
			# import_id
			# schedule_data
		end

		create table("room_events", primary_key: false) do
			add :id, :binary_id, null: false, primary_key: true
			add :room_id, references("rooms", type: :uuid), null: false
			add :sender_id, references("users", type: :uuid), null: false
			add :timestamp, :utc_datetime_usec, null: false
			add :type, :string, null: false
			add :content, :map
			# edited
			# replaces
		end
	end
end
