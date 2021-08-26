import Config



config :venueless, Venueless.Db.Repo,
	database: System.get_env("VENUELESS_DB_NAME"),
	username: System.get_env("VENUELESS_DB_USER"),
	password: System.get_env("VENUELESS_DB_PASS"),
	hostname: System.get_env("VENUELESS_DB_HOST")

config :venueless, ecto_repos: [Venueless.Db.Repo]

if config_env() == :prod do
	config :logger,
		level: :error,
		compile_time_purge_matching: [
			[level_lower_than: :error]
		]
end
