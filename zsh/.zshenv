# vim:fdm=marker

# Profiling                                                                 {{{1
# ==============================================================================

# Enable profiling (display report with `zprof`)
zmodload zsh/zprof

# For coarser profiling, wrap blocks with time commands
# { time (
# ...
# ) }

# Conditional inclusion                                                     {{{1
# ==============================================================================

# Usage: if-darwin && { echo foo }
function if-darwin() { [[ "$(uname)" == "Darwin" ]]; }
function if-linux() { [[ "$(uname)" == "Linux" ]]; }

# Usage: if-work-machine && { echo foo }
function if-work-machine() { [[ "$(scutil --get ComputerName)" == "ELSLAPM-156986" ]]; }
function if-personal-machine() { [[ "$(scutil --get ComputerName)" == "stubillwhite-macbook-pro" ]] || [[ "$(scutil --get ComputerName)" == "stubillwhite-ThinkPad-X240" ]] ; }

# Source script if it exists
# Usage: source-if-exists ".my-functions"
function source-if-exists() { 
    local fnam=$1

    if [[ -e "${fnam}" ]]; then
        source "${fnam}"
    fi
}

# Source script if it exists
# Usage: source-or-warn ".my-functions"
function source-or-warn() { 
    local fnam=$1

    if [[ -e "${fnam}" ]]; then
        source "${fnam}"
    else
        echo "Skipping sourcing ${fnam} as it does not exist"
    fi
}

# Included scripts                                                          {{{1
# ==============================================================================

# GNU parallel
source-or-warn /usr/local/bin/env_parallel.zsh

# Include common configuration
source-or-warn $HOME/.commonrc

# Secrets                           {{{2
# ======================================

source-or-warn "$HOME/.zshenv.no-commit"

function _assert-variables-defined() {
    local variables=("$@")
    for variable in "${variables[@]}"
    do
        if [[ -z "${(P)variable}" ]]; then
            echo "${variable} is not defined -- please check ~/.zshenv.no-commit"
        fi
    done
}

EXPECTED_SECRETS=(
    SECRET_ACC_CONTENT_SC_CONTENT_PROD
    SECRET_ACC_CONTENT_SC_NON_PROD
    SECRET_ACC_CONTENT_SD_CONTENT_BACKUP
    SECRET_ACC_CONTENT_SD_CONTENT_NON_PROD
    SECRET_ACC_CONTENT_SD_CONTENT_PROD
    SECRET_ACC_RT_DATA_PLATFORM_NON_PROD
    SECRET_ACC_RT_DATA_PLATFORM_PROD
    SECRET_JIRA_API_KEY
    SECRET_JIRA_USER
    SECRET_NEWRELIC_API_KEY
    SECRET_OPENAI_API_KEY
    SECRET_SLACK_WEBHOOK_URL
    SECRET_SPOTIFY_CLIENT_ID
    SECRET_SPOTIFY_CLIENT_SECRET
    SECRET_TABLEAU_API_USER
    SECRET_TABLEAU_API_KEY
)

_assert-variables-defined "${EXPECTED_SECRETS[@]}"

export OPENAI_API_KEY=${SECRET_OPENAI_API_KEY}

# General settings                                                          {{{1
# ==============================================================================

export COLOR_RED='\033[0;31m'
export COLOR_GREEN='\033[0;32m'
export COLOR_YELLOW='\033[0;33m'
export COLOR_NONE='\033[0m'
export COLOR_BLUE="\033[0;34m"
export COLOR_MAGENTA="\033[0;35m"
export COLOR_CYAN="\033[0;36m"
export COLOR_CLEAR_LINE='\r\033[K'

# Display success message
# msg-success "Something succeeded"
function msg-success() {
    declare msg=$1
    printf "${CLEAR_LINE}${COLOR_GREEN}✔ ${msg}${COLOR_NONE}\n"
}

# Display a warning message
# msg-error "An error occurred"
function msg-error() {
    declare msg=$1
    printf "${CLEAR_LINE}${COLOR_RED}✘ ${msg}${COLOR_NONE}\n"
}

