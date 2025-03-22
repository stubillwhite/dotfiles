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
function if-work-machine() { [[ "$(scutil --get ComputerName)" == "ELSLOWM-404903" ]]; }
function if-personal-machine() { [[ "$(scutil --get ComputerName)" == "stubillwhite-macbook-pro" ]] || [[ "$(scutil --get ComputerName)" == "stubillwhite-ThinkPad-X240" ]] ; }

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

export PATH=~/dev/tools/bin:$PATH
export PATH=/usr/local/opt/ruby/bin:$PATH
export PATH=/usr/local/opt/coreutils/libexec/gnubin:$PATH
export PATH=/usr/local/opt/make/libexec/gnubin:$PATH
export PATH=/Applications/Emacs.app/Contents/MacOS:$PATH

export PATH=$PATH:/usr/local/lib/ruby/gems/3.0.0/bin
export PATH=$PATH:/Applications/Beyond\ Compare.app/Contents/MacOS
export PATH=$PATH:/Applications/PyCharm\ CE.app/Contents/MacOS
export PATH=$PATH:/Applications/IntelliJ\ IDEA\ CE.app/Contents/MacOS
export PATH=$PATH:~/dev/my-stuff/shell-utils
export PATH=$PATH:/usr/bin
export PATH=$PATH:~/.local/bin

export XDG_CONFIG_HOME="$HOME/.config"

# Included scripts                                                          {{{1
# ==============================================================================

# GNU parallel
source-or-warn /opt/homebrew/bin/env_parallel.zsh

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
    SECRET_LASTFM_API_KEY
    SECRET_LASTFM_SECRET
    SECRET_TABLEAU_API_USER
    SECRET_TABLEAU_API_KEY
    SECRET_GITHUB_USERNAME
    SECRET_GITHUB_TOKEN
)

_assert-variables-defined "${EXPECTED_SECRETS[@]}"

export OPENAI_API_KEY=${SECRET_OPENAI_API_KEY}

# General settings                                                          {{{1
# ==============================================================================

# GCC
export LDFLAGS="-L/usr/local/opt/ruby/lib"
export CPPFLAGS="-I/usr/local/opt/ruby/include"
export PKG_CONFIG_PATH="/usr/local/opt/ruby/lib/pkgconfig"

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

function ssh-start-agent {
    echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV_FILE}"
    /bin/chmod 600 "${SSH_ENV_FILE}"
    . "${SSH_ENV_FILE}" > /dev/null
    /usr/bin/ssh-add;
}

if [ -f "${SSH_ENV_FILE}" ]; then
    . "${SSH_ENV_FILE}" > /dev/null
    /bin/ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
    ssh-start-agent;
}
else
    ssh-start-agent;
fi
