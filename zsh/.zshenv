# vim:fdm=marker

# Profiling                                                                 {{{1
# ==============================================================================

# Enable profiling (display report with `zprof`)
zmodload zsh/zprof

# For coarser profiling, wrap blocks with time commands
# { time (
# ...
# ) }

# Shared environment                                                         {{{1
# ==============================================================================

if [ -f "$HOME/.shell_env" ]; then
    . "$HOME/.shell_env"
fi

# Conditional inclusion                                                     {{{1
# ==============================================================================

# Usage: if-darwin && { echo foo }
function if-darwin() { [[ "${OS_NAME}" == "Darwin" ]]; }
function if-linux() { [[ "${OS_NAME}" == "Linux" ]]; }

# Usage: if-work-machine && { echo foo }
function if-work-machine() { [[ "${COMPUTER_NAME}" == "ELSLOWM-404903" ]]; }
function if-personal-machine() { [[ "${COMPUTER_NAME}" == "stubillwhite-macbook-pro" ]] || [[ "${COMPUTER_NAME}" == "stubillwhite-ThinkPad-X240" ]] ; }

# Source script if it exists
# Usage: source-if-exists ".my-functions"
function source-if-exists() { 
    local fnam=$1

    source "${fnam}" > /dev/null 2>&1
}

# Source script if it exists
# Usage: source-or-warn ".my-functions"
function source-or-warn() { 
    local fnam=$1

    source "${fnam}" > /dev/null 2>&1 || echo "Skipping ${fnam} as it does not exist"
}

# Included scripts                                                          {{{1
# ==============================================================================

# GNU parallel
source-or-warn "${HOMEBREW_PREFIX}/bin/env_parallel.zsh"
# Shell
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

# SSH                                                                       {{{1
# ==============================================================================

SSH_ENV_FILE="$HOME/.ssh/environment"

function ssh-agent-start {
    echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV_FILE}"
    /bin/chmod 600 "${SSH_ENV_FILE}"
    . "${SSH_ENV_FILE}" > /dev/null
    /usr/bin/ssh-add;
}

function ssh-agent-running() {
    [[ -n "${SSH_AGENT_PID}" ]] \
        && [[ -n "${SSH_AUTH_SOCK}" ]] \
        && [[ -S "${SSH_AUTH_SOCK}" ]] \
        && kill -0 "${SSH_AGENT_PID}" 2> /dev/null
}

if [ -f "${SSH_ENV_FILE}" ]; then
    . "${SSH_ENV_FILE}" > /dev/null
    ssh-agent-running || ssh-agent-start
else
    ssh-agent-start;
fi
