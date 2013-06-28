#!/bin/bash
# ------------------------------------------------------------------------------
# Vagrant - Virtualized Development 
# Copyright(c) pgRouting Contributors
#
# Run this to create a Redmine project
# ------------------------------------------------------------------------------

set -e # Exit script immediately on first error.
#set -x # Print commands and their arguments as they are executed.

DATABASE=${1:-"gtt-demo"}

# Creating database
echo "Creating a database '$DATABASE'"
createdb -U postgres -E UTF8 $DATABASE
psql -U postgres -d $DATABASE -c "CREATE SCHEMA app;" 
psql -U postgres -d $DATABASE -c "CREATE SCHEMA dev;" 

# Setup Redmine
cd /vagrant
cp vagrant/config/*.yml config/
sed -i -e 's/MYDATABASE/'${DATABASE}'/g' config/database.yml

# Clone plugins
if [ ! -d "plugins/gtt_core" ]; then
	git clone gitolite@code.georepublic.net:GTT/gtt_core.git plugins/gtt_core
fi

if [ ! -d "plugins/gtt_custom" ]; then
	git clone gitolite@code.georepublic.net:GTT/gtt_custom.git plugins/gtt_custom
fi

# Install Redmine
echo "Installing Redmine"
bundle install --without test mysql sqlite

RAILS_ENV=production rake generate_secret_token
RAILS_ENV=production rake db:migrate
RAILS_ENV=production rake redmine:plugins:migrate

RAILS_ENV=development rake generate_secret_token
RAILS_ENV=development rake db:migrate
RAILS_ENV=development rake redmine:plugins:migrate

# Sample data
#RAILS_ENV=development rake redmine:load_default_data
#RAILS_ENV=development rake redmine:load_default_data

# Create directories
mkdir -p tmp tmp/pdf public/plugin_assets
sudo chown -R vagrant:vagrant files log tmp public/plugin_assets
sudo chmod -R 777 files log tmp public/plugin_assets

echo "!!! Start server with 'ruby /vagrant/script/rails server webrick -e production|development'!!!"

