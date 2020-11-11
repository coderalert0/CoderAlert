#!/bin/bash
set -e
# Remove a potentially pre-existing server.pid for Rails.
rm -f /coder_alert/tmp/pids/server.pid
# Wait for database running:
sleep 5
while [[ $(nc -z $DATABASE_HOST 5432 &> /dev/null; echo $?) -ne 0 ]]; do echo pod is not running;sleep 3; done
echo $MASTER_KEY > /coder_alert/config/master.key
# Migrate the database before running:
rake db:migrate
# RUN SUPERVISOR for process
exec /usr/bin/supervisord
