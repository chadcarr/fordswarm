#!/bin/sh

# Add puppet repo to sources
wget https://apt.puppetlabs.com/puppet6-release-bionic.deb
dpkg -i puppet6-release-bionic.deb

# Update the package cache and the system
export DEBIAN_FRONTEND=noninteractive
apt-get update
#apt-get -y upgrade

# Install required puppet components
if [ "$1" = "controller" ]; then
    apt-get -y install puppetserver
    systemctl start puppetserver
elif [ "$1" = "worker" ]; then
    apt-get -y install puppet-agent
fi