defmodule Venueless do
	use Application

	def start(_type, _args) do
		children = [
			{Plug.Cowboy, scheme: :http, dispatch: dispatch(), plug: Venueless.Router, port: 8375},
			{Venueless.WorldSupervisor, []},
			{Registry, [keys: :unique, name: Venueless.WorldRegistry]},
			{DynamicSupervisor, strategy: :one_for_one, name: Venueless.UserSupervisor},
			{Registry, [keys: :unique, name: Venueless.UserRegistry]}
		]

		# See https://hexdocs.pm/elixir/Supervisor.html
		# for other strategies and supported options
		Supervisor.start_link(children, [strategy: :one_for_one, name: Venueless.Supervisor])
		world_config = Jason.decode!(File.read!('./world.json'))
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
