defmodule Venueless.Router do
	use Plug.Router

	plug Plug.Static,
		at: "/",
		from: :venueless
	plug :match
	plug Plug.Parsers,
		parsers: [:json],
		pass: ["application/json"],
		json_decoder: Jason
	plug :dispatch

	match _ do
		send_resp(conn, 404, "404")
	end
end
