#!/bin/bash

suppOS="Liux"
SSH="ssh -l vagrant"

for k in .vagrant/machines/*/virtualbox/private_key; do
    SSH+=" -i $k"
done

rexec() {
    local user=root
    local host=$1 # default to bare host - user and port are optional
    local port=22

    # Host may be plain host or ip, user@host, host:port
    # or the trifecta: user@host:port

    # user may precede @ 
    [[ $1 =~ ^(.*)@ ]] && {
        user=${BASH_REMATCH[1]}
    }

    # host may follow an @ or precede a :
    [[ $1 =~ @([^@:]*) ]] && {
        host=${BASH_REMATCH[1]}
    }
    [[ $1 =~ ([^@:]*): ]] && {
        host=${BASH_REMATCH[1]}
    }

    # port may follow a :
    [[ $1 =~ :(.*)$ ]] && {
        port=${BASH_REMATCH[1]};
    }

    local code=$2 # single-quoted code to be executed remotely
    shift 2 # shift off the first two args...
    local refs=("$@") # the rest are namerefs for remote code

    {
        declare -p "${refs[@]}"
        echo "$code"
    }# | $SSH -p $port $host sudo -u $user "bash -s"
}

declare -A hosts=(
    [control]='localhost:2222'
    [work1]='127.0.0.1:2200'
    [work2]='127.0.0.1:2201'
)

for host in "${!hosts[@]}"; do
    echo "Remote exec on $host"
    output=$(rexec ${hosts[$host]} '
        id
        hostname
        hostOS=$(uname -s)
        [[ $hostOS == $suppOS ]] || echo "Error: running on $hostOS not supported, this script supports $suppOS" >&2
    ' suppOS)
    echo "$output"
    rexec ${hosts[$host]} geteuid.sh
done