defmodule Venueless do
	use Application
	require Logger

	alias Venueless.Db

	def start(_type, _args) do
		children = [
			Venueless.Db.Repo,
			{Plug.Cowboy, scheme: :http, dispatch: dispatch(), plug: Venueless.Router, port: 8375},
			{Venueless.WorldSupervisor, []},
			{Registry, [keys: :unique, name: Venueless.WorldRegistry]},
			{Registry, [keys: :unique, name: Venueless.RoomRegistry]},
			{DynamicSupervisor, strategy: :one_for_one, name: Venueless.UserSupervisor},
			{Registry, [keys: :unique, name: Venueless.UserRegistry]}
		]

		# See https://hexdocs.pm/elixir/Supervisor.html
		# for other strategies and supported options
		Supervisor.start_link(children, [strategy: :one_for_one, name: Venueless.Supervisor])
		world_config = Jason.decode!(File.read!('./world.json'))
		world = case Db.Repo.get(Db.World, world_config["id"]) do
			nil ->
				world = Db.Repo.insert!(%Db.World{
					id: world_config["id"],
					title: world_config["title"],
					config: world_config
				})
				Enum.each(world_config["rooms"], fn room ->
					Db.Repo.insert!(%Db.Room{
						world: world,
						name: room["name"],
						modules: room["modules"]
					})
				end)
			world -> world
		end
		Logger.info(world)
		Venueless.WorldSupervisor.start_child(world_config)
	end

	defp dispatch do
		[
			{:_,
				[
					{"/ws/world/:world", Venueless.Socket, []},
					{:_, Plug.Cowboy.Handler, {Venueless.Router, []}}
				]
			}
		]
	end
end
