#!/bin/bash

echo ">>> Cleaning up unclean PIDs"
rm -f /project/tmp/pids/*.pid

echo ">>> Migrating database"
rake db:migrate

echo ">>> Starting webserver"
bundle exec unicorn -p 4000 -c /project/config/unicorn.rb
