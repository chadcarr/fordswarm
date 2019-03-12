#!/bin/bash
# This script might be passed to rexec() for remote execution.

# source ./common/base.sh # Cannot source local code in rexec scripts
# (But network.sh exports useful constants and functions from local libraries)

loglevel=$DEBUG

os=$(uname -s)
[[ $os == $supported_os ]] || error "$host runs $os, this script only supports $supported_os"

debug "euid = $(id -u)"
info "host = $(hostname), id = $(id)"
warn "euid = $(id -u)"
error "euid = $(id -u)"
critical "euid = $(id -u)"