#!/bin/bash
# Shell provisioner for vagrant - just enough to get the system updated
# and habitat installed so that vagrant can run the chef solo provisioner.

# Update the cache and system
#zypper refresh
#zypper --non-interactive update

[[ -f /bin/hab ]] \
    || curl https://raw.githubusercontent.com/habitat-sh/habitat/master/components/hab/install.sh | bash

useradd -m -U hab

cp /vagrant/hab-sup.service /etc/systemd/system && systemctl daemon-reload
systemctl enable hab-sup
systemctl start hab-sup