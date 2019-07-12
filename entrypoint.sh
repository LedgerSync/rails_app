#!/bin/sh

# Compile the assets
bundle exec rake assets:precompile

# Run the CMD
exec "$@"
