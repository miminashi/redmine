#!/bin/bash
# ------------------------------------------------------------------------------
# Vagrant - Virtualized Development 
# Copyright(c) pgRouting Contributors
#
# Virtual environment bootstrap script
# ------------------------------------------------------------------------------

set -e # Exit script immediately on first error.
#set -x # Print commands and their arguments as they are executed.

# Abort provisioning if pgRouting development environment already setup.
# ------------------------------------------------------------------------------
which vim >/dev/null &&
{ echo "Development environment already setup."; exit 0; }

# Enable PPA support
# ------------------------------------------------------------------------------
apt-get update -qq
apt-get install -y -qq python-software-properties vim

# Add PPA's'
# ------------------------------------------------------------------------------
apt-add-repository -y ppa:ubuntugis/ubuntugis-unstable
apt-get update -qq

# Set system locale to UTF8
# ------------------------------------------------------------------------------
export LANGUAGE="en_US.UTF-8"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
locale-gen en_US.UTF-8
dpkg-reconfigure locales

# Run provisioning
# ------------------------------------------------------------------------------
echo "Installing packages ... this may take some time."
apt-get -y -qq install 				\
	vim git-core 					\
	ruby1.9.1-dev libpgsql-ruby 	\
	libmagickwand-dev 				\
	postgresql-server-dev-all 		\
	postgresql-9.1-postgis

gem1.9.1 install rails
gem1.9.1 install rmagick

# copy pg_hba.conf file and restart PostgreSQL
cd /vagrant
cp vagrant/config/pg_hba.conf /etc/postgresql/9.1/main/
service postgresql restart

# Actually wanted to setup a Redmine instance here pulling in Git repositories
# But vagrant up doesn't support SSH forwarding, so I can't pull from private repositories
# https://github.com/mitchellh/vagrant/issues/1735

echo '!!! Provisioning is complete. If vagrant has not yet exited, please press CTRL-C twice.    !!!'
echo '!!! After login with`vagrant ssh`, run the `setup.sh` script to install a Redmine instance.!!!'

