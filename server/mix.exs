defmodule Venueless.MixProject do
	use Mix.Project

	def project do
		[
			app: :venueless,
			version: "0.1.0",
			elixir: "~> 1.11",
			start_permanent: Mix.env() == :prod,
			deps: deps()
		]
	end

	# Run "mix help compile.app" to learn about applications.
	def application do
		[
			extra_applications: [:logger, :plug_cowboy],
			mod: {Venueless, []}
		]
	end

	# Run "mix help deps" to learn about dependencies.
	defp deps do
		[
			{:plug_cowboy, "~> 2.0"},
			{:jason, "~> 1.2"},
			{:exsync, "~> 0.2", only: :dev},
			{:ecto_sql, "~> 3.0"},
			{:postgrex, ">= 0.0.0"},
		]
	end
end
