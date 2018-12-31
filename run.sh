#!/bin/sh

set -e

# Ensure the app's dependencies are installed
mix deps.get

# Prepare Dialyzer if the project has Dialyxer set up
if mix help dialyzer >/dev/null 2>&1
then
  echo "Found Dialyxer: Setting up PLT..."
  mix do deps.compile, dialyzer --plt
else
  echo "No Dialyxer config: Skipping setup..."
fi

# Install JS libraries
echo "Installing JS..."
cd assets && npm install
cd ..

# Potentially Set up the database
mix ecto.create
mix ecto.migrate

echo "Launching Phoenix web server..."
# Start the phoenix web server
mix phx.server
