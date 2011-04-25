#!/bin/bash
# Author:: Eric G. Wolfe <wolfe21@marshall.edu>
# Copyright:: Copyright (c) 2011
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

RVM_DIR="/opt/chef"
RUBY_VERSION="1.9.2-p180"
CHEF_PATH="$RVM_DIR/gems/ruby-$RUBY_VERSION/bin"
INIT_DIR="./distro"

if [ $1 ]; then
  CHEF_VERSION=$1
else
  CHEF_VERSION=0.9.16
fi

if [ -e /etc/redhat-release ]; then
  echo -en "Installing rvm pre-requisites for RHEL/CentOS/Fedora\n"
  yum -y install gcc-c++ patch readline readline-devel zlib zlib-devel openssl-devel rsync git

  # rsync the rvm-chef installation into place
  echo -en "Deploying rvm and chef-client config files\n"
  rsync -a ./etc/ /etc

  echo -en "Installing RedHat-style system/init scripts\n"
  cp -f $INIT_DIR/redhat/etc/init.d/chef-client /etc/init.d/chef-client

  if [ ! -f /etc/sysconfig/chef-client ]; then
    cp $INIT_DIR/redhat/etc/sysconfig/chef-client /etc/sysconfig/chef-client
  fi
  if [ ! -f /etc/logrotate.d/chef-client ]; then
    cp $INIT_DIR/redhat/etc/logrotate.d/chef-client /etc/logrotate.d/chef-client
  fi

elif [ -e /etc/debian_version ]; then
  echo -en "Installing rvm pre-requisites for Debian/Ubuntu\n"
  apt-get -y install build-essential bison openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-0 libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev rsync

  # rsync the rvm-chef installation into place
  echo -en "Deploying rvm and chef-client config files\n"
  rsync -a ./etc/ /etc

  echo -en "Installing Debian-style system/init scripts\n"

  cp -f $INIT_DIR/debian/etc/init.d/chef-client /etc/init.d/chef-client

  if [ ! -f /etc/init/chef-client.conf ]; then
    cp $INIT_DIR/debian/etc/init/chef-client.conf /etc/init/chef-client.conf
  fi
  if [ ! -f /etc/default/chef-client ]; then
    cp $INIT_DIR/debian/etc/default/chef-client /etc/default/chef-client
  fi

fi

# Just-in-time install
echo -en "Beginning the Just-In-Time install process\n"
bash < <(curl -s https://rvm.beginrescueend.com/install/rvm) 2>&1 > /dev/null
. /etc/profile.d/rvm.sh
RVM=`which rvm`
$RVM install $RUBY_VERSION 
$RVM use $RUBY_VERSION
$RVM --default $RUBY_VERSION
$RVM gem install --no-ri --no-rdoc chef -v $CHEF_VERSION
$RVM cleanup all

# Symlink chef-client for init script
if [ -f /usr/bin/chef-client ]; then
  echo -en "Backing up chef-client to chef-client.backup\n";
  mv /usr/bin/chef-client /usr/bin/chef-client.backup
fi

echo -en "Symlinking $CHEF_PATH/chef-client to /usr/bin\n"
ln -s $CHEF_PATH/chef-client /usr/bin/chef-client

echo
cat << "EOF"
= CHEF JUST-IN-TIME INSTALLER

Author:: Eric G. Wolfe <wolfe21@marshall.edu>
Copyright:: Copyright (c) 2011
License:: Apache License, Version 2.0

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
mitations under the License.
EOF

echo
echo -e "----------------------------------------------------------------\n"
echo -e "Additional components (RVM, Ruby, gems, and Chef) are copyright their respective authors.\n"
echo -e "This Chef application deployment is provided as-is by Eric G. Wolfe\n"
echo -e "You should be able to run chef-client -S <chef-server> after sourcing /etc/profile.d/rvm.sh\n"
