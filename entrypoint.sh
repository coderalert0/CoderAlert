#!/bin/bash
set -e
# Set the database variable based on ENVIRONMENT VARIABLE
sed -i '/host:/c\  host: '$DATABASE_HOST'' config/database.yml
sed -i '/username:/c\  username: '$DATABASE_USER'' config/database.yml
sed -i '/database:/c\  database: '$DATABASE_NAME'' config/database.yml
sed -i '/password:/c\  password: '$DATABASE_PASSWORD'' config/database.yml
echo $CREDENTIALS > config/credentials.yml.enc
cat config/database.yml
# Remove a potentially pre-existing server.pid for Rails.
rm -f /coder_alert/tmp/pids/server.pid
# Wait for database running:
sleep 5
while [[ $(nc -z $DATABASE_HOST 5432 &> /dev/null; echo $?) -ne 0 ]]; do echo pod is not running;sleep 3; done
# Migrate the database before running:
rake db:migrate
# RUN SUPERVISOR for process
exec /usr/bin/supervisord
