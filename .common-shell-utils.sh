# vim:fdm=marker

# Constants                                                                 {{{1
# ==============================================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NO_COLOR='\033[0m'
CLEAR_LINE='\r\033[K'

# Functions                                                                 {{{1
# ==============================================================================

# Dump the current stacktrace
function dump_stacktrace() {
    echo 'Stacktrace:'
    if [[ $BASH_VERSION ]]; then
        local file=${BASH_SOURCE[1]##*/} func=${FUNCNAME[1]} line=${BASH_LINENO[0]}
        for ((i=1; i<${#FUNCNAME[@]}-1; i++))
        do
            echo "  ${BASH_SOURCE[$i+1]}:${BASH_LINENO[$i]} ${FUNCNAME[$i]}(...)"
        done
    else  # zsh
        emulate -L zsh  # because we may be sourced by zsh `emulate bash -c`
        # $funcfiletrace has format:  file:line
        [[ $func =~ / ]] && func=source  # $func may be filename. Use bash behaviour
        for ((i=1; i<${#funcfiletrace[@]}-1; i++))
        do
            local file=${funcfiletrace[$i+1]%:*} line=${funcfiletrace[$i+1]##*:}
            local func=${funcstack[$i+1]}
            echo "  ${file}:${line} ${func}(...)"
        done
    fi
}

# Assert that there are N arguments, exiting if this is not the case
# assert_arg_count_is 2 $*
function assert_arg_count_is() {
    declare count=$1
    
    shift

    if [ "$((count))" -eq $# ]; then 
        return 0 
    else 
        if [[ $BASH_VERSION ]]; then
            func="${FUNCNAME[1]}"
        else
            emulate -L zsh  # because we may be sourced by zsh `emulate bash -c`
            # $funcfiletrace has format:  file:line
            [[ $func =~ / ]] && func=source  # $func may be filename. Use bash behaviour
            func="${funcstack[2]}"
        fi

        echo "${func} expected $count arguments but recieved '$*'"
        dump_stacktrace
        return 1
    fi
}

# Set the script to exit on error
function set_exit_on_error() {
    set -e
}

# Set the script to continue on error
function set_continue_on_error() {
    set +e
}

# Display a normal message
# msg_normal "Something happened"
function msg_normal() {
    msg=$1
    printf "${CLEAR_LINE}${msg}\n"
}

function on_nonzero_exit() {
    exitCode=$?
    if [[ $exitCode != 0 ]]; then "$@"; fi
}

# Display a progress message
# msg_in_progress "Installing something" 1 3
function msg_in_progress() {
    msg=$1
    curr=$2
    steps=$3
    printf "${CLEAR_LINE}[${curr}/${steps}] ${msg}"
    if [[ $curr = $steps ]]; then printf "\n"; fi
}

# Display success message
# msg_success "Something succeeded"
function msg_success() {
    msg=$1
    printf "${CLEAR_LINE}${GREEN}✔ ${msg}${NO_COLOR}\n"
}

# Display an info message
# msg_info "Something happened"
function msg_info() {
    msg=$1
    printf "${CLEAR_LINE}ⓘ ${msg}\n"
}

# Display a warning message
# msg_warn "Something possibly bad happened"
function msg_warning() {
    msg=$1
    printf "${CLEAR_LINE}${YELLOW}⚠ ${msg}${NO_COLOR}\n"
}

# Display a warning message
# msg_error "An error occurred"
function msg_error() {
    msg=$1
    printf "${CLEAR_LINE}${RED}✘ ${msg}${NO_COLOR}\n"
}

# Validate the arguments match the function requirements, displaying usage and returning error if not
# validate_usage "my-cmd a b c" 3 "$@" || return 1
function validate_usage() {
    declare usage="$1" count="$2"

    shift
    shift

    if [ "$((count))" -eq $# ]; then 
        return 0 
    else 
        echo "${usage}"
        echo "Expected $count argument(s) but recieved '$*'"
        return 1
    fi
}

# Test code                                                                 {{{1
# ==============================================================================

function example_usage() {
    set_exit_on_error

    msg_normal "Installing pre-requisites"

    msg_in_progress "Installing something" 1 3
    sleep 0.25
    msg_in_progress "Installing something else" 2 3
    sleep 0.25
    msg_in_progress "Installing another thing" 3 3
    sleep 0.25

    set_continue_on_error
    ls foo > /dev/null
    on_nonzero_exit msg_error "Tool foo not installed"
    #set_exit_on_error

    msg_normal "Done"

    msg_info "This is an informational"
    msg_warning "This is a warning"
    msg_error "This is an error"
    msg_success "This is a success"
}

function foo() {
    assert_arg_count_is 2 $*
}

#example_usage
#set_continue_on_error
#foo b c d
#on_nonzero_exit msg_error "Failed to execute script"


#function git-foreach-repo() {
    #local f=$1
    #for fnam in *; do
        #if [[ -d $fnam ]]; then
            #pushd "$fnam" || return 1
            #if git rev-parse --git-dir > /dev/null 2>&1; then
                #$f
            #fi
            #popd
        #fi
    #done
#}

#function list-files() {
    #ls
#}

#function white-test() {
    #git-foreach-repo list-files
#} 
