#!/bin/sh

PUPPET_PLATFORM="puppet6-release"

# Add puppet platform repo to apt sources if needed
if ! dpkg-query -W -f '${Status}\n' $PUPPET_PLATFORM | grep "install ok installed"; then
    wget https://apt.puppetlabs.com/${PUPPET_PLATFORM}-bionic.deb \
        && dpkg -i ${PUPPET_PLATFORM}-bionic.deb \
        && rm ${PUPPET_PLATFORM}-bionic.deb
fi

# Update the package cache and the system, then install puppet-agent.
# This bootstraps a node that can run "puppet apply" to apply the
# basic manifest (bootstrap-puppet.pp) which will continue the 
# configuration of each node into a proper puppet server or agent.
apt-get update
apt-get -y upgrade
apt-get -y install puppet-agent