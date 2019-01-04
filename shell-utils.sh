#!/bin/sh
# vim:fdm=marker

# Constants {{{1

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NO_COLOR='\033[0m'
CLEAR_LINE='\r\033[K'

# 1}}}

# Functions {{{1

function set_exit_on_error() {
    set -e
}

function set_continue_on_error() {
    set +e
}

function msg_normal() {
    msg=$1
    printf "${CLEAR_LINE}${msg}\n"
}

function on_nonzero_exit() {
    exitCode=$?
    if [[ $exitCode != 0 ]]; then "$@"; fi
}

function msg_in_progress() {
    msg=$1
    curr=$2
    steps=$3
    printf "${CLEAR_LINE}[${curr}/${steps}] ${msg}"
    if [[ $curr = $steps ]]; then printf "\n"; fi
}

function msg_success() {
    msg=$1
    printf "${CLEAR_LINE}${GREEN}✔   ${msg}${NO_COLOR}\n"
}

function msg_info() {
    msg=$1
    printf "${CLEAR_LINE}ⓘ   ${msg}\n"
}

function msg_warning() {
    msg=$1
    printf "${CLEAR_LINE}${YELLOW}⚠   ${msg}${NO_COLOR}\n"
}

function msg_error() {
    msg=$1
    printf "${CLEAR_LINE}${RED}✘   ${msg}${NO_COLOR}\n"
}

# 1}}}

# Example {{{1

function example_usage() {
    set_exit_on_error

    msg_normal "Installing pre-requisites"

    msg_in_progress "Installing something" 1 3
    sleep 1.5
    msg_in_progress "Installing something else" 2 3
    sleep 1.5
    msg_in_progress "Installing another thing" 3 3
    sleep 1.5

    set_continue_on_error
    ls foo > /dev/null
    on_nonzero_exit msg_error "Tool foo not installed"
    set_exit_on_error

    msg_normal "Done"

    msg_info "This is an informational"
    msg_warning "This is a warning"
    msg_error "This is an error"
    msg_success "This is a success"
}

# }}}

example_usage
