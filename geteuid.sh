#!/bin/bash
# This script might be passed to rexec() for remote execution.

# source ./common/base.sh # Cannot source local code in rexec scripts
# (But network.sh exports useful constants and functions from local libraries)

loglevel=$DEBUG

debug "euid = $(id -u)"
info "host = $(hostname), id = $(id)"
warn "euid = $(id -u)"
err "euid = $(id -u)"