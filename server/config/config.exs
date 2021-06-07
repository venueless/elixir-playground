import Config

config :venueless, Venueless.Db.Repo,
	database: System.get_env("VENUELESS_DB_NAME"),
	username: System.get_env("VENUELESS_DB_USER"),
	password: System.get_env("VENUELESS_DB_PASS"),
	hostname: System.get_env("VENUELESS_DB_HOST")

config :venueless, ecto_repos: [Venueless.Db.Repo]
