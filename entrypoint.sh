#!/bin/bash
set -e
# Create SSH folder
USER_SSH_KEYS_FOLDER=~/.ssh
[ ! -d "$USER_SSH_KEYS_FOLDER" ] && mkdir -p $USER_SSH_KEYS_FOLDER

# Add SSH_KEY
echo $SSH_PUBLIC_KEY > ~/.ssh/authorized_keys
# Remove a potentially pre-existing server.pid for Rails.
rm -f /coder_alert/tmp/pids/server.pid
# Wait for database running:
sleep 5
while [[ $(nc -z $DATABASE_HOST 5432 &> /dev/null; echo $?) -ne 0 ]]; do echo pod is not running;sleep 3; done
# Migrate the database before running:
rake db:migrate

if [ $RAILS_ENV  == "development" ]; then
  exec "$@"
else
  exec /usr/bin/supervisord
fi
