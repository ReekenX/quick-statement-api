#!/bin/bash

echo ">>> Cleaning up unclean PIDs"
rm -f /project/tmp/pids/*.pid

echo ">>> Migrating database"
rake db:migrate

echo ">>> Starting webserver"
rails server -b 0.0.0.0 -p 4000
