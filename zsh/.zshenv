# vim:fdm=marker

# Profiling                                                                 {{{1
# ==============================================================================

# Enable profiling (display report with `zprof`)
zmodload zsh/zprof

# For coarser profiling, wrap blocks with time commands
# { time (
# ...
# ) }

# Constants                                                                 {{{1
# ==============================================================================

case "${OSTYPE}" in
    darwin*)
        export OS_NAME="Darwin"
        ;;
    linux*)
        export OS_NAME="Linux"
        ;;
    *)
        export OS_NAME="$(uname -s)"
        ;;
esac

export DOTFILES_ROOT="$HOME/Dev/my-stuff/dotfiles"

export COMPUTER_NAME=""
if [[ "${OS_NAME}" == "Darwin" ]] && command -v scutil > /dev/null 2>&1; then
    export COMPUTER_NAME="$(scutil --get ComputerName 2> /dev/null)"
fi

HOMEBREW_PREFIX=""
for candidate in /opt/homebrew /usr/local
do
    if [[ -d "${candidate}/opt" ]]; then
        HOMEBREW_PREFIX="${candidate}"
        break
    fi
done

export PREZTO_ROOT="$HOME/Dev/my-stuff/prezto"

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

# Paths                                                                     {{{1
# ==============================================================================

typeset -U path

function append-path-if-exists() {
    local dir=$1
    [[ -d "${dir}" ]] && path+=("${dir}")
}

if [[ -n "${HOMEBREW_PREFIX}" ]]; then
    append-path-if-exists "${HOMEBREW_PREFIX}/opt/ruby/bin"
    append-path-if-exists "${HOMEBREW_PREFIX}/opt/coreutils/libexec/gnubin"
    append-path-if-exists "${HOMEBREW_PREFIX}/opt/make/libexec/gnubin"
fi

append-path-if-exists "/Applications/Emacs.app/Contents/MacOS"
append-path-if-exists "/Applications/Obsidian.app/Contents/MacOS"
append-path-if-exists "/Applications/Beyond Compare.app/Contents/MacOS"
append-path-if-exists "/Applications/PyCharm.app/Contents/MacOS"
append-path-if-exists "/Applications/IntelliJ IDEA CE.app/Contents/MacOS"

append-path-if-exists "$HOME/Dev/my-stuff/shell-utils"

append-path-if-exists "/usr/bin"
append-path-if-exists "$HOME/.local/bin"

export XDG_CONFIG_HOME="$HOME/.config"

# export FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

# Included scripts                                                          {{{1
# ==============================================================================

# GNU parallel
source-or-warn "${HOMEBREW_PREFIX}/bin/env_parallel.zsh"

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
    SECRET_ANTHROPIC_API_KEY
    SECRET_GITHUB_TOKEN
    SECRET_GITHUB_USERNAME
    SECRET_JIRA_API_KEY
    SECRET_JIRA_USER
    SECRET_LASTFM_API_KEY
    SECRET_LASTFM_SECRET
    SECRET_NEWRELIC_API_KEY
    SECRET_OPENAI_API_KEY
    SECRET_PORTKEY_API_KEY
    SECRET_SLACK_WEBHOOK_URL
    SECRET_SPOTIFY_CLIENT_ID
    SECRET_SPOTIFY_CLIENT_SECRET
    SECRET_TABLEAU_API_KEY
    SECRET_TABLEAU_API_USER
)

_assert-variables-defined "${EXPECTED_SECRETS[@]}"

export OPENAI_API_KEY=${SECRET_OPENAI_API_KEY}

# General settings                                                          {{{1
# ==============================================================================

# Leiningen
export LEIN_JVM_OPTS='-Xms4G -Xmx4G'

# Spark
export SPARK_LOCAL_IP=127.0.0.1

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
