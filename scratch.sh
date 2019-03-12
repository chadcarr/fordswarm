#!/bin/bash
# This type of script would be called by a Jenkins freestyle project
# using . ./scratch.sh

. ./common/base.sh
. ./common/network.sh

loglevel=$DEBUG

ssh+=" -l vagrant"
for k in .vagrant/machines/*/virtualbox/private_key; do
    ssh+=" -i $k"
done

supported_os="Linux"

rexec --user vagrant --host 127.0.0.1 --port 2222 --file geteuid.sh supported_os
rexec --port 2200 --file geteuid.sh supported_os
rexec --host 127.0.0.1 --port 2201 --file /dev/null supported_os