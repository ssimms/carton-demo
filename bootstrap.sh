#!/usr/bin/env bash

NAME=ts_carton_demo
DB_NAME=demo
DB_USER=carton
DB_PASS=local

apt-get update
apt-get install -y cpanminus postgresql libdbd-pg-perl libcairo2 libcairo2-dev libcrypt-ssleay-perl
cpanm -n Carton Starman

cd /vagrant
carton install --cached

export PGPASSWORD="$DB_PASS"

sudo -u postgres psql -c "CREATE USER $DB_USER WITH PASSWORD '$DB_PASS'"
sudo -u postgres psql -c "CREATE DATABASE $DB_NAME WITH OWNER $DB_USER"

# Install the TS::App schema
perl -Ilocal/lib/perl5 -MTS::App::Schema -e "print TS::App::Schema->schema()" \
  | psql -h localhost $DB_NAME $DB_USER

# Install the local app schema (if applicable)
if [ -f schema.sql ]; then
  cat schema.sql | psql -h localhost $DB_NAME $DB_USER
fi

cp /vagrant/init-script.sh /etc/init.d/$NAME
update-rc.d $NAME defaults
/etc/init.d/$NAME start
