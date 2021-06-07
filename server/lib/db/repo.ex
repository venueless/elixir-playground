defmodule Venueless.Db.Repo do
	use Ecto.Repo,
		otp_app: :venueless,
		adapter: Ecto.Adapters.Postgres
end
