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

suppOS="Linux"

declare -A roles=(
    [control]='localhost:2222'
    [work1]='vagrant@127.0.0.1:2200'
    [work2]='127.0.0.1:2201'
)

for role in "${!roles[@]}"; do
    info "remote exec on $role"
    output=$(rexec ${roles[$role]} '
        df -h
        hostOS=$(uname -s)
        [[ $hostOS == $suppOS ]] || err "running on $hostOS not supported, this script supports $suppOS"
    ' suppOS)
    echo "$output"
    rexec ${roles[$role]} geteuid.sh
done