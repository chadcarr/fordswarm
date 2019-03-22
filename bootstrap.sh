#!/bin/bash
# Shell provisioner for vagrant - just enough to get the system updated
# and habitat installed so that habitat can run the chef zero provisioner.

# Update the cache and system
#zypper refresh
#zypper --non-interactive update

[[ -f /bin/hab ]] \
    || curl https://raw.githubusercontent.com/habitat-sh/habitat/master/components/hab/install.sh | bash

id -un hab 2> /dev/null || useradd -m -U hab # Add home directory and user group
