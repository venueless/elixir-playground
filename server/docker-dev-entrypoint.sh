#!/bin/bash
# Apply database migrations

# mix ecto.drop
mix ecto.create
echo "Apply database migrations"
mix ecto.migrate

# Start server
echo "Starting server"
exec mix run --no-halt
