# vim:fdm=marker

# Zsh initialisation                                                        {{{1
# ==============================================================================

# Completion system                 {{{2
# ======================================

fpath=(~/.zsh-completion $fpath)

autoload -Uz compinit

function maybe-regenerate-zcompdump() {
    local fnam=${HOME}/.zcompdump
    local fnam=/Users/white1/.zcompdump
    local fnam=tmp.txt

    # Globbing pattern (#qN.mh+24):
    # - '#q'    Enable glob inside Zsh [[ ]]
    # - 'N'     Glob pattern evaluates to nothing when it doesn't match instead of erroring
    # - '.'     Match regular files
    # - 'mh+24' Matches things that are older than 24 hours

    ls -ahl ${fnam}
    if [[ -e "${fnam}" && -f "${fnam}(#qN.mh+24)" ]]; then
        echo Updating ${fnam}
        compinit
    else
        echo Not updating ${fnam}
    fi
}

#maybe-regenerate-zcompdump
compinit -C

# Included scripts                                                          {{{1
# ==============================================================================

# Prezto                            {{{2
# ======================================

source-or-warn ~/Dev/my-stuff/prezto/runcoms/zshenv

# Include Prezto, but remove unhelpful configuration

zstyle ':prezto:module:git:alias' skip 'yes' # No Git aliases

source-if-exists "$HOME/.zprezto/init.zsh"

unalias cp &> /dev/null              # Standard behaviour
unalias rm &> /dev/null              # Standard behaviour
unalias mv &> /dev/null              # Standard behaviour
unalias grep &> /dev/null            # Standard behaviour
setopt clobber                       # Happily clobber files
setopt interactivecomments           # Allow comments in interactive shells
unsetopt AUTO_CD                     # Don't change directory automatically
unsetopt AUTO_PUSHD                  # Don't push directory automatically
unsetopt PATH_DIRS                   # Don't automcomplete foo/bar to my_path_dir/foo/bar

# https://github.com/zsh-users/zsh-completions/issues/314
#zstyle ':completion::users' ignored-patterns '*'
#zstyle ':completion:*:*:*:users' ignored-patterns '*'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# direnv                            {{{2
# ======================================

eval "$(direnv hook zsh)"

# General preferences                                                       {{{1
# ==============================================================================

# Unlimited history
# export HISTFILESIZE=
# export HISTSIZE=

# Use NVim
export EDITOR=nvim
export VISUAL=nvim

# General options                                                           {{{1
# ==============================================================================

setopt BASH_REMATCH             # Bash regex support
setopt menu_complete            # Tab autocompletes first option even if ambiguous

# Aliases                                                                   {{{1
# ==============================================================================

if-darwin && {
    alias gif-recorder='/Applications/LICEcap.app/Contents/MacOS/licecap'
}

if-linux && {
    alias gsed='sed'
    alias gecho='echo'
    alias gawk='awk'
    alias open='xdg-open'
}

# More helpful aliases for programs that change frequently
alias gg='rg'                                                               # Grep

# Better command defaults
alias env='env | sort'                                                      # env should be sorted
alias tree='tree -A'                                                        # tree should be ascii
alias entr='entr -c'                                                        # entr should be colourised
alias gh='NO_COLOR=1 gh'                                                    # gh should not be colourised
alias vi='nvim'                                                             # Use nvim instead of vi
alias vim='nvim'                                                            # Use nvim instead of vim
alias python='python3'                                                      # Use Python 3
alias pip='pip3'                                                            # Use Pip for Python 3
alias sed='gsed'                                                            # Use gsed instead of sed
alias touch='gtouch'                                                        # Use gtouch instead of touch
alias echo='gecho'                                                          # Use gecho nstead of echo
alias date='gdate'                                                          # Use gdate instead of date
alias find='gfind'                                                          # Use gfind instead of find
alias pygmentize='pygmentize -O style=nord-darker'                          # Default to nord-darker style for pygmentize
alias rsync='rsync -r --progress'                                           # Default to recursive and show progress

alias nvim-lua='NVIM_APPNAME=nvim-lua nvim'

# Other useful stuff
alias reload-zsh-config="exec zsh"                                          # Reload Zsh config
alias zsh-startup='time zsh -i -c exit'                                     # Display Zsh start-up time
alias display-colours='msgcat --color=test'                                 # Display terminal colors
alias ssh-add-keys='ssh-add ~/.ssh/keys/id_rsa_personal'                    # Add standard keys to SSH agent
alias list-ports='netstat -anv'                                             # List active ports
alias new-react-app='npx create-react-app'                                  # Shortcut to create a new React app
alias fzv='fzf --bind "enter:become(nvim {})"'                              # Fuzzy-find a file and open Vim

# No flow control, so C-s is free for C-r/C-s back/forward incremental search
stty -ixon

# IntelliJ and Pycharm                                                      {{{1
# ==============================================================================

function _launch-jetbrains-tool() {
    local cmd=$1
    shift
    local args=$@

    if [[ $# -eq 0 ]] ; then
        args='.'
    fi

    zsh -c "${cmd} ${args} > /dev/null 2>&1 &"
}
compdef _files _launch-jetbrains-tool

alias charm='_launch-jetbrains-tool pycharm'                                # Launch PyCharm
alias idea='_launch-jetbrains-tool idea'                                    # Launch IntelliJ

# Minor machine-specific differences                                        {{{1
# ==============================================================================

if-darwin && {
    alias emacs='/Applications/Emacs.app/Contents/MacOS/Emacs'
    alias emacsclient='echo "When done with a buffer, type C-x #" && /Applications/Emacs.app/Contents/MacOS/bin/emacsclient'
    alias doom='emacs --with-profile doom'
    alias bankrupcy='emacs --with-profile bankrupcy'
    alias sqlworkbenchj='java -jar /Applications/SQLWorkbenchJ.app/Contents/Java/sqlworkbench.jar &'
}

# Link ~/trash to the recycle bin                                           {{{1
# ==============================================================================

if-linux && {
    if [ ! -d "$HOME/trash" ]; then ln -s "$HOME/.local/share/Trash" "$HOME/trash"; fi
}

if-darwin && {
    if [ ! -d "$HOME/trash" ]; then ln -s "$HOME/.Trash" "$HOME/trash"; fi
}

# General functions                                                         {{{1
# ==============================================================================

# Useful things to pipe into        {{{2
# ======================================

alias format-xml='xmllint --format -'                                       # Prettify XML (cat foo.xml | format-xml)
alias format-json='jq "."'                                                  # Prettify JSON (cat foo.json | format-json)
alias as-stream='stdbuf -o0'                                                # Turn pipes to streams (tail -F foo.log | as-stream grep "bar")
alias strip-color="gsed -r 's/\x1b\[[0-9;]*m//g'"                           # Strip ANSI colour codes (some-cmd | strip-color)
alias strip-ansi="perl -pe 's/\x1b\[[0-9;]*[mG]//g'"                        # Strip all ANSI control codes (some-cmd | strip-ansi)
alias strip-quotes='gsed "s/[''\"]//g"'                                     # Strip all quotes (some-cmd | strip-quotes)
alias syntax-highlight='pygmentize -g'                                      # Syntax highlighting (some-cmd | syntax-highlight)
alias sum-of="paste -sd+ - | bc"                                            # Sum numbers from stdin (some-cmd | sum-of)
alias utf-16-to-8="iconv -f 'utf-16' -t 'utf-8'"                            # Convert UTF-16 stream to UTF-8
alias get-hostname='gsed -e "s|^\(https\?://\)\?\([^/:]\+\).*$|\2|"'        # Grab hostname from URI

# Tabluate TSV
# cat foo.tsv | tabulate-by-tab
function tabulate-by-tab() {
    gsed 's/\t\t/\t-\t/g' \
        | column -t -s $'\t'
}

# Tabluate CSV
# cat foo.csv | tabulate-by-comma
function tabulate-by-comma() {
    gsed 's/,,/,-,/g' \
        | column -t -s '',''
}

# Tabluate by space
# cat foo.txt | tabulate-by-space
function tabulate-by-space() {
    column -t -s ' '
}

# Prepend a line of text to output
# cat data.csv | prepend "Results are below:"
function prepend() {
    local text=$@
    echo "$@"
    cat -
}

# Tabluate CSV (cat foo.csv | tabulate-by-comma)
# "gsed -r ':loop;/,,/{s//,-,/g;b loop}'"
alias stabulate-by-comma="gsed -r 's/^,/-,/g' \
    | gsed -r ':loop;/,,/{s//,-,/g;b loop}' \
    | gsed -r 's/,$/,-/g' \
    | column -t -s '','' "

alias csv-to-json="python3 -c 'import csv, json, sys; print(json.dumps([dict(r) for r in csv.DictReader(sys.stdin)]))'"
alias json-to-csv='jq -r ''(.[0] | keys_unsorted), (.[] | to_entries | map(.value)) | @csv'''
alias json-to-tsv='jq -r ''(.[0] | keys_unsorted), (.[] | to_entries | map(.value)) | @tsv'''

# File helpers                      {{{2
# ======================================

# Display the full path of a file
# full-path ./foo.txt
function full-path() {
    declare fnam=$1

    if [ -d "$fnam" ]; then
        (cd "$fnam"; pwd)
    elif [ -f "$fnam" ]; then
        if [[ $fnam == */* ]]; then
            echo "$(cd "${1%/*}"; pwd)/${1##*/}"
        else
            echo "$(pwd)/$fnam"
        fi
    fi
}

# Tar a file
# tarf my-dir
function tarf() {
    declare fnam=$1
    tar -zcvf "${fnam%/}".tar.gz "$1"
}

# Untar a file
# untarf my-dir.tar.gz
function untarf() {
    declare fnam=$1
    tar -zxvf "$1"
}

# Remove an entry from $PATH
# path-remove "/usr/local/bin/python-old-version"
function path-remove() {
    if [[ $# -ne 1 ]] ; then
        echo 'Usage: path-remove PATH'
        return 1
    fi

    local toRemove=$1
    export PATH=$(echo $PATH | tr ":" "\n" | grep -v "${toRemove}" | xargs | tr ' ' ':')
}

# Long running jobs                 {{{2
# ======================================

# Notify me when something completes
# Usage: do-something-long-running ; tell-me "optional message"
function tell-me() {
    exitCode="$?"

    if [[ $exitCode -eq 0 ]]; then
        exitStatus="SUCCEEDED"
    else
        exitStatus="FAILED"
    fi

    if [[ $# -lt 1 ]] ; then
        msg="${exitStatus}"
    else
        msg="${exitStatus} : $1"
    fi

    if-darwin && {
        osascript -e "display notification \"$msg\" with title \"tell-me\""
    }

    if-linux && {
        notify-send -t 2000 "tell-me" "$msg"
    }
}

# Helper function to notify when the output of a command changes
# Usage:
#   function watch-directory() {
#       f() {
#           ls
#       }
#
#       notify-on-change f 1 "Directory contents changed"
#   }
function notify-on-change() {
    local f=$1
    local period=$2
    local message=$3
    local tmpfile=$(mktemp)

    $f > "${tmpfile}"

    {
        while true
        do
            sleep ${period}
            (diff "${tmpfile}" <($f)) || break
        done

        tell-me "${message}"
    } > /dev/null 2>&1 & disown
}

# Miscellaneous utilities           {{{2
# ======================================

# Extract text from an image
# image-to-text FNAM
function image-to-text() {
    if [[ $# -ne 1 ]] ; then
        echo 'Usage: image-to-text FNAM'
        return 1
    fi

    local destName=$(basename ${1:t:r})
    tesseract $1 ${destName}

    local dest=${destName}.txt
    cat ${dest}
    rm ${dest}
}

# Prompt for confirmation
# confirm "Delete [y/n]?" && rm -rf *
function confirm() {
    read response\?"${1:-Are you sure? [y/n]} "
    case "$response" in
        [Yy][Ee][Ss]|[Yy])
            true ;;
        *)
            false ;;
    esac
}

# Read HEREDOC into a variable
# read-heredoc myVariable <<'HEREDOC'
# this is
# multiline text
# HEREDOC
# echo $myVariable
function read-heredoc() {
    local varName=${1:-reply}
    shift

    local newlineChar=$'\n'

    local value=""
    while IFS="${newlineChar}" read -r line; do
        value="${value}${line}${newlineChar}"
    done

    eval ${varName}'="${value}"'
}


# Highlight output using sed regex
# cat my-log.txt | highlight red ERROR | highlight yellow WARNING
function highlight() {
    if [[ $# -ne 2 ]] ; then
        echo 'Usage: highlight COLOR PATTERN'
        echo '  COLOR   The color to use (red, green, yellow, blue, magenta, cyan)'
        echo '  PATTERN The sed regular expression to match'
        return 1
    fi

    color=$1
    pattern=$2

    declare -A colors
    colors[red]="\033[0;31m"
    colors[green]="\033[0;32m"
    colors[yellow]="\033[0;33m"
    colors[blue]="\033[0;34m"
    colors[magenta]="\033[0;35m"
    colors[cyan]="\033[0;36m"
    colors[default]="\033[0m"

    colorOn=$(echo -e "${colors[$color]}")
    colorOff=$(echo -e "${colors[default]}")

    gsed -u s"/$pattern/$colorOn\0$colorOff/g"
}
compdef '_alternative \
    "arguments:custom arg:(red green yellow blue magenta cyan)"' \
    highlight

# Convert milliseconds since the epoch to date time
# echo 1633698951550 | epoch-to-date
function epoch-to-date() {
    while IFS= read -r msSinceEpoch; do
        gawk -v t="${msSinceEpoch}" 'BEGIN { print strftime("%Y-%m-%d %H:%M:%S", t/1000); }'
    done
}

# Convert date time to milliseconds since the epoch
# echo '2021-10-08 14:15:51' | date-to-epoch
function date-to-epoch() {
    while IFS= read -r dateStr; do
        local epochSeconds=$(date --date="${dateStr}" +"%s")
    done
    echo $(( ${epochSeconds} * 1000 ))
}

# Display a time in the timezones we collaborate with
# clock 
# clock 12:30
function() clock() {
    local currTimeArgs=""
    if [[ $# -eq 1 ]]; then
        currTimeArgs="--date=$1"
    fi

    local currTime=$(date ${currTimeArgs})

    # gfind -H /usr/share/zoneinfo/ -type f | gsed 's|/usr/share/zoneinfo/||g' | sort
    local TIMEZONES=(
        "America/Mexico_City:Mexico"
        "EST:East US"
        "GMT:London"
        "CET:Amsterdam"
        "Asia/Kolkata:India"
    )

    for timezone in "${TIMEZONES[@]}"
    do
        local fields=("${(s/:/)timezone}")
        local timezoneCode=${fields[1]}
        local description=${fields[2]}

        local currTimeInTimezone=$(TZ=${timezoneCode} date -d ${currTime} '+%Y-%m-%d %H:%M %Z')
        echo "${description},${currTimeInTimezone}"
    done | tabulate-by-comma
}

# Calculate the result of an expression
# calc 2 + 2
function calc () {
    echo "scale=2;$*" | bc | sed 's/\.0*$//'
}

# Copy my base machine config to a remote host
function copy-skeleton-config() {
    if [[ $# -ne 1 ]] ; then
        echo 'Usage: copy-skeleton-config HOST'
        return -1
    fi

    pushd ~/Dev/my-stuff/dotfiles/skeleton-config || return 1
    echo "Uploading config to $1"
    rsync --progress -v . $1:.
    popd || return 1
}
compdef _ssh copy-skeleton-config=ssh

# Generate a UUID
function uuid() {
    uuidgen | tr '[A-Z]' '[a-z]'
}

# Kill process by name
function ps-kill() {
    if [[ $# -ne 1 ]] ; then
        echo 'Usage: ps-kill NAME'
        return 1
    fi

    local process=$(ps aux | grep -i $1 | grep -v grep | gsed -e 's/ \+/ /g')
    if [[ -n "${process}" ]]; then
        local processName=$(echo ${process} | gcut -d ' ' -f 11-)
        local processID=$(echo ${process} | gcut -d ' ' -f 2)
        confirm "Kill '${processName}' [y/n]?" && {
            kill ${processID}
        }
    fi
}

# Fast AI course helpers            {{{2
# ======================================

function fast-ai-setup() {
    export PATH=~/anaconda/bin:$PATH
    export AWS_DEFAULT_PROFILE=stubillwhite
    source-if-exists "/Users/white1/Dev/my-stuff/fast-ai/courses/setup/aws-alias.sh"
    echo "Using anaconda tools and defaulting to AWS profile for fast-ai course"
}

function fast-ai-tunnel-open() {
    if [[ $# -ne 3 ]] ; then
        echo 'Usage: tunnel-open LOCALPORT SERVER SERVERPORT'
        return -1
    fi

    localPort=$1
    server=$2
    serverPort=$3
    connectionFile=~/.ssh-tunnel-localhost:${localPort}===${server:0:20}:${serverPort}

    echo "Opening tunnel localhost:${localPort} -> ${server}:${serverPort}"
    ssh -L ${localPort}:localhost:${serverPort} ${server} -i ~/.ssh/aws-key-fast-ai.pem -f -o ServerAliveInterval=30 -N -M -S ${connectionFile} || { echo "Failed to open tunnel"; return -1; }
    echo "Tunnel open ${connectionFile}"
}
alias tunnel-fast-ai='fast-ai-tunnel-open 8888 fast-ai-server 8888'

# Multi-project configurations      {{{2
# ======================================

# Switch artefact resolution for SBT/Maven/Ivy between configurations
function artefact-config () {
    ARTEFACT_DIRS=(
        ".m2"
        ".ivy2"
        ".sbt"
    )

    if [[ $# -ne 1 ]] ; then
        echo 'Usage: artefact-config CONFIG'
        echo
        echo 'Current config:'
        for file in "${ARTEFACT_DIRS[@]}"
        do
            echo "~/${file} -> $(readlink ~/$file)"
        done \
            | tabulate-by-space
        return 1
    fi

    local config="${1}"

    local artefactConfigDir=.artefact-config

    for file in "${ARTEFACT_DIRS[@]}"
    do
        local src="${HOME}/${artefactConfigDir}/${config}/${file}"
        local dst="${HOME}/${file}"

        if [[ -e ${src} ]]; then

            if [[ (-e ${dst}) && ! (-L "${dst}" && -d "${dst}") ]]; then
                msg-error "Error: ${dst} exists and is not a symbolic link"
            else
                unlink "${dst}" || msg-error "Error: ${dst} not found, not removing"
                ln -s "${src}" "${dst}"
            fi

        else
            unlink "${dst}"
            msg-error "Error: ${src} not found, not creating new link"
        fi
    done
}
compdef "_arguments \
    '1:environment arg:(recs recs-cleanroom dkp)'" \
    artefact-config

# Clean all artefacts from the current configuration
function artefact-config-clean() {
    echo 'Current artefact configuration:'
    echo "  $(realpath ~/.m2)"
    echo "  $(realpath ~/.ivy2)"
    echo "  $(realpath ~/.sbt)"
    confirm "Really remove artefacts [y/n]?" && {
        rm -rf ~/.m2/repository/
        rm -rf ~/.ivy2/cache/
        rm -rf ~/.ivy2/jars/
        rm -rf ~/.ivy2/local/
    }
}

# Switch SSH config between configurations
function ssh-config () {
    if [[ $# -ne 1 ]] ; then
        echo 'Usage: ssh-config CONFIG'
        return 1
    fi

    local config="${1}"

    local configDir="${HOME}/.ssh/ssh-configs"

    local src="${configDir}/${config}-ssh-config"
    local dst="${HOME}/.ssh/config"

    if [[ -e ${src} ]]; then

        if [[ (-e ${dst}) && ! (-L "${dst}") ]]; then
            msg-error "Error: ${dst} exists and is not a symbolic link"
        else
            unlink "${dst}"
            ln -s "${src}" "${dst}"
        fi

    else
        msg-error "Error: ${src} not found"
    fi
}
compdef "_arguments \
    '1:environment arg:(recs personal)'" \
    ssh-config

# Specific tools                                                            {{{1
# ==============================================================================

# AWS authentication                {{{2
# ======================================

alias aws-which="env | grep AWS | sort"
alias aws-clear-variables="for i in \$(aws-which | cut -d= -f1,1 | paste -); do unset \$i; done"

# Look at
#   https://ben11kehoe.medium.com/you-only-need-to-call-aws-sso-login-once-for-all-your-profiles-41a334e1b37e
#   https://docs.aws.amazon.com/cli/latest/userguide/sso-configure-profile-token.html
function aws-sso-login() {
    local profile=$1

    aws sso login --profile ${profile}

    local ssoCachePath=~/.aws/sso/cache

    local ssoAccountId=$(aws configure get --profile ${profile} sso_account_id)
    local ssoRoleName=$(aws configure get --profile ${profile} sso_role_name)
    local mostRecentSSOLogin=$(ls -t1 ${ssoCachePath}/*.json | head -n 1)

    local response=$(aws sso get-role-credentials \
        --role-name ${ssoRoleName} \
        --account-id ${ssoAccountId} \
        --access-token "$(jq -r '.accessToken' ${mostRecentSSOLogin})" \
        --region eu-west-1
    )

    local accessKeyId=$(echo "${response}" | jq -r '.roleCredentials | .accessKeyId')
    local secretAccessKey=$(echo "${response}" | jq -r '.roleCredentials | .secretAccessKey')
    local sessionToken=$(echo "${response}" | jq -r '.roleCredentials | .sessionToken')

    local expireAfter=$(date -d "+3 hours" --iso-8601=s)

    export AWS_ACCESS_KEY_ID="${accessKeyId}"
    export AWS_SECRET_ACCESS_KEY="${secretAccessKey}"
    export AWS_SESSION_TOKEN="${sessionToken}"
    export AWS_DEFAULT_REGION="us-east-1"
    export AWS_REGION="us-east-1"

    echo
    aws-which
}

function aws-recs-login() {
    if [[ $# -ne 1 ]]; then
        echo "Usage: aws-recs-login (dev|staging|live)"
    else
        local recsEnv=$1

        case "${recsEnv}" in
            dev*)
                aws-sso-login recs-dev
            ;;

            staging*)
                aws-sso-login recs-dev
            ;;

            live*)
                aws-sso-login recs-prod
            ;;

            *)
                echo "ERROR: Unrecognised environment ${recsEnv}"
                return -1
            ;;
        esac
    fi
}
compdef "_arguments \
    '1:environment arg:(dev staging live)'" \
    aws-recs-login

function aws-login() {
    local project=$1
    local environment=$2
    aws-sso-login "${project}-${environment}"
}

alias aws-logout=aws-clear-variables

alias aws-whoami='aws sts get-caller-identity | jq'

function aws-account-info() {
    print 'Account name:  ' $(aws iam list-account-aliases | jq -r ".AccountAliases[]")
    print 'Account number:' $(aws sts get-caller-identity  | jq -r ".Account")
}

function aws-ssh-send-key() {
    if [[ $# -ne 1 ]]; then
        echo "Usage: aws-ssh-send-key INSTANCE_ID"
        return 1
    fi

    local instanceId=$1
    AWS_PAGER="" aws ec2-instance-connect send-ssh-public-key \
        --instance-id ${instanceId} \
        --instance-os-user ec2-user \
        --ssh-public-key file://~/.ssh/keys/id_rsa.pub
}

function aws-ssh-send-key-for-ip() {
    if [[ $# -ne 1 ]]; then
        echo "Usage: aws-ssh-send-key-for-ip IP"
        return 1
    fi

    local ipAddress=$1

    local output=$(
        aws ec2 describe-instances \
            --output text \
            --query 'Reservations[*].Instances[*].[InstanceId,Placement.AvailabilityZone,PrivateIpAddress]' \
            --filter "Name=private-ip-address,Values=${ipAddress}" \
            | tr ',' \t
    )

    local instanceId=$(echo "${output}" | cut -f 1)
    local availabilityZone=$(echo "${output}" | cut -f 2)

    echo "Sending key to ${instanceId}"
    local success=$(AWS_PAGER="" aws ec2-instance-connect send-ssh-public-key \
        --instance-id ${instanceId} \
        --instance-os-user ec2-user \
        --ssh-public-key file://~/.ssh/keys/id_rsa.pub \
        | jq '.Success'
    )
    echo "Success: ${success}"
}

function aws-persist-credentials() {
    if [[ $# -ne 1 ]]; then
        echo "Usage: aws-persist-credentials PROFILE"
        return 1
    fi

    local name=$1

    local profile
    read-heredoc profile <<HEREDOC

[${name}]
aws_access_key_id=${AWS_ACCESS_KEY_ID}
aws_default_region=${AWS_DEFAULT_REGION}
aws_region=${AWS_REGION}
aws_secret_access_key=${AWS_SECRET_KEY}
aws_session_token=${AWS_SESSION_TOKEN}
HEREDOC

    echo ${profile} >> ~/.aws/credentials
}

function aws-unpersist-credentials() {
    if [[ $# -ne 1 ]]; then
        echo "Usage: aws-unpersist-credentials PROFILE"
        return 1
    fi

    local name=$1

    perl -i -pe "BEGIN{undef $/;} s/\[${name}\][^[]*//smg" ~/.aws/credentials
}

# AWS                               {{{2
# ======================================

# AWS CLI commands pointing at localstack
alias aws-localstack='AWS_DEFAULT_REGION=us-east-1 aws --endpoint-url=http://localhost:4566'

# List ECR images
function aws-ecr-images() {
    local repos=$(aws ecr describe-repositories \
        | jq -r ".repositories[].repositoryName" \
        | sort)

    while IFS= read -r repo; do
        echo $repo
        AWS_PAGER="" aws ecr describe-images --repository-name "${repo}" \
            | jq -r '.imageDetails[] | select(has("imageTags")) | .imageTags[] | select(test( "^\\d+\\.\\d+\\.\\d+$" ))' \
            | sort
        echo
    done <<< "$repos"
}

# Log into ECR
function aws-ecr-login() {
    local region="us-east-1"

    local accountId=$(aws sts get-caller-identity  | jq -r ".Account")

    aws ecr get-login-password --region "${region}" | docker login --username AWS --password-stdin "${accountId}.dkr.ecr.${region}.amazonaws.com"
    echo "Pull images with:"
    echo "  " docker pull "${accountId}.dkr.ecr.${region}.amazonaws.com/IMAGE:VERSION"
}

# Describe OpenSearch clusters
function aws-opensearch-describe-clusters() {
    while IFS=, read -rA domainName
    do
        aws opensearch describe-domain --domain-name "${domainName}"
    done < <(aws opensearch list-domain-names | jq -r -c '.DomainNames[].DomainName') \
        | jq -s \
        | jq -r '["DomainName", "InstanceType", "InstanceCount", "MasterType", "MasterCount"],(.[].DomainStatus | [.DomainName, (.ClusterConfig | .InstanceType, .InstanceCount, .DedicatedMasterType, .DedicatedMasterCount)]) | @tsv' \
        | tabulate-by-tab
}

# List lambda statuses
function aws-lambda-statuses() {
    aws lambda list-event-source-mappings \
        | jq -r ".EventSourceMappings[] | [.FunctionArn, .EventSourceArn, .State, .UUID] | @tsv" \
        | tabulate-by-tab \
        | sort \
        | highlight red '.*Disabled.*' \
        | highlight yellow '.*\(Enabling\|Disabling\|Updating\).*'
}

# List EMR statuses
function aws-emr-status() {
    if [[ $# -ne 1 ]]; then
        echo "Usage: aws-recs-login CLUSTER_ID"
    else
        local clusterId=$1
        aws emr list-steps \
            --cluster-id "${clusterId}" \
            | jq -r '.Steps[] | [.Name, .Status.State, .Status.Timeline.StartDateTime, .Status.Timeline.EndDateTime] | @csv' \
            | column -t -s ',' \
            | sed 's/"//g'

        aws emr describe-cluster \
            --cluster-id "${clusterId}" \
            | jq -r ".Cluster | (.LogUri + .Id)" \
            | sed 's/s3n:/s3:/'
    fi
}

# Open the specified S3 bucket in the web browser
function aws-s3-open() {
    local s3Path=$1
    echo "Opening '$s3Path'"
    echo "$s3Path" \
        | gsed -e 's/^.*s3:\/\/\(.*\)/\1/' \
        | gsed -e 's/^/https:\/\/s3.console.aws.amazon.com\/s3\/buckets\//' \
        | gsed -e 's/$/?region=us-east-1/' \
        | xargs open
}

# Display available IPs in each subnet
function aws-subnet-available-ips() {
    aws ec2 describe-subnets \
        | jq -r ".Subnets[] | [ .SubnetId, .AvailableIpAddressCount ] | @tsv" \
        | strip-quotes \
        | tabulate-by-tab
}

# Display service quotas for EC2
function aws-ec2-service-quotas() {
    aws service-quotas list-service-quotas --service-code ec2 \
        | jq -r '(.Quotas[] | ([.QuotaName, .Value])) | @tsv' \
        | strip-quotes \
        | tabulate-by-tab
}

# Download data pipeline definitions to local files
function aws-datapipeline-download-definitions() {
    while IFS=, read -rA x
    do
        pipelineId=${x[@]:0:1}
        pipelineName=$(echo "${x[@]:1:1}" | tr '[A-Z]' '[a-z]' | tr ' ' '-')
        echo $pipelineName
        aws datapipeline get-pipeline-definition --pipeline-id $pipelineId \
            | jq '.' \
            > "pipeline-definition-${pipelineName}.json"
    done < <(aws datapipeline list-pipelines | jq --raw-output '.pipelineIdList[] | [.id, .name] | @csv' | strip-quotes) \
}

# Display data pipeline instance requirements
function aws-datapipeline-instance-requirements() {
    while IFS=, read -rA x
    do
        pipelineId=${x[@]:0:1}
        pipelineName=${x[@]:1:1}
        aws datapipeline get-pipeline-definition --pipeline-id $pipelineId \
            | jq --raw-output ".values | [\"$pipelineName\", .my_master_instance_type, \"1\", .my_core_instance_type, .my_core_instance_count, .my_env_subnet_private]| @csv"
    done < <(aws datapipeline list-pipelines | jq --raw-output '.pipelineIdList[] | [.id, .name] | @csv' | strip-quotes) \
        | strip-quotes \
        | tabulate-by-comma
}

# Display AWS secrets
function aws-secrets() {
    local secretsNames=$(aws secretsmanager list-secrets | jq -r '.SecretList[].Name')

    while IFS= read -r secret ; do
        echo ${secret}
        aws secretsmanager list-secrets \
            | jq -r ".SecretList[] | select(.Name == \"$secret\") | .Tags[] // [] | select(.Key == \"Description\") | .Value"
        aws secretsmanager get-secret-value --secret-id "$secret"\
            | jq '.SecretString | fromjson'
        echo
    done <<< "${secretsNames}"
}

# Turn an AWS hostname into an IP
function aws-ip() {
    local hostname=$1
    echo "${hostname}" | sed -r 's/ip-(.+)\.ec2\.internal/\1/g' | sed -r 's/-/./g'
}

# List AWS SageMaker endpoints
function aws-sagemaker-endpoints() {
    if [[ $# -ne 1 ]]; then
        echo "Usage: aws-sagemaker-endpoints (dev|staging|live)"
        return 1
    fi

    local recsEnv="${1}"
    aws-recs-login "${recsEnv}" > /dev/null

    aws sagemaker list-endpoints \
        | jq -r '["EndpointName", "CreationTime"], (.Endpoints[] | [.EndpointName, .CreationTime]) | @tsv' \
        | tabulate-by-tab
}
compdef "_arguments \
    '1:environment arg:(dev staging live)'" \
    aws-sagemaker-endpoints

# List AWS SageMaker Feature Store
function aws-feature-groups() {
    if [[ $# -ne 1 ]]; then
        echo "Usage: aws-feature-groups (dev|staging|live)"
        return 1
    fi

    local recsEnv="${1}"
    aws-recs-login "${recsEnv}" > /dev/null

    aws sagemaker list-feature-groups \
        | jq -r '["Name", "Creation time", "Status", "Offline store status"], (.FeatureGroupSummaries[] | [.FeatureGroupName, .CreationTime, .FeatureGroupStatus, .OfflineStoreStatus.Status]) | @tsv' \
        | tabulate-by-tab
}
compdef "_arguments \
    '1:environment arg:(dev staging live)'" \
    aws-feature-groups

function aws-bucket-sizes() {
    local endTime=$(date --iso-8601=seconds)
    local startTime=$(date --iso-8601=seconds -d "-2 day")

    local buckets=$(aws s3 ls | cut -d ' ' -f 3)

    while read -r bucketName; do
        local region=$(aws s3api get-bucket-location --bucket ${bucketName} | jq -r ".LocationConstraint")

        if [[ ${region} = "null" ]]; then
            region='us-east-1'
        fi

        local size=$(aws cloudwatch get-metric-statistics \
            --namespace AWS/S3 \
            --start-time ${startTime} \
            --end-time ${endTime} \
            --period 86400 \
            --statistics Average \
            --region ${region} \
            --metric-name BucketSizeBytes \
            --dimensions Name=BucketName,Value=${bucketName} Name=StorageType,Value=StandardStorage \
            | jq ".Datapoints[].Average" \
            | tail -n 1 
        )

        [[ -z "${size}" ]] && size="?"

        printf "%-7s %-10s %s\n" ${size} ${region} ${bucketName}
    done < <(echo ${buckets})
}

function white-test() {
    local sinceDate=$(gdate -d "-2 days" --iso-8601=seconds)
    local clusterIds=$(aws emr list-clusters --created-after "${sinceDate}" | jq -r '.Clusters[].Id')

    while read -r clusterId; do
        echo "${clusterId}"
        aws emr describe-cluster --cluster-id "${clusterId}" \
            | jq -r "{ clusterId: .Cluster.Id, clusterName: .Cluster.Name, name: .Cluster.InstanceGroups[].Name, type: .Cluster.InstanceGroups[].InstanceType, groupType: .Cluster.InstanceGroups[].InstanceGroupType, count: .Cluster.InstanceGroups[].RequestedInstanceCount }" \
            | jq -r --slurp \
            | json-to-csv \
            | strip-quotes \
            | tabulate-by-comma
        echo
    done < <(echo ${clusterIds} | head -n 3)
}

# Azure                             {{{2
# ======================================

function az-login() {
     az login -u white1@science.regn.net -o table
}

#
# cookiecutter                      {{{2
# ======================================

alias cookiecutter-new-python='cookiecutter https://github.com/stubillwhite/cookiecutters --directory python'

#
# Docker                            {{{2
# ======================================

function docker-rm-instances() {
    docker ps -a -q | xargs docker stop
    docker ps -a -q | xargs docker rm
}

function docker-rm-images() {
    if confirm; then
        docker-rm-instances
        docker images -q | xargs docker rmi
        docker images | grep "<none>" | gawk '{print $3}' | xargs docker rmi
    fi
}

function docker-update() {
    docker desktop start
    docker desktop update
    docker desktop stop
}

# FZF                               {{{2
# ======================================

export FZF_DEFAULT_COMMAND="fd --exclude={.git,.idea,.vscode,target,node_modules,build} --type f --hidden"

# Git                               {{{2
# ======================================

export GIT_TRUNK=main

function git-set-trunk() {
    if [[ $# -ne 1 ]] ; then
        echo 'Usage: git-set-trunk GIT_TRUNK'
        return 1
    fi

    export GIT_TRUNK=$1
    echo "GIT_TRUNK set to ${GIT_TRUNK}"
}
compdef "_arguments \
    '1:branch arg:(main master)'" \
    git-set-trunk

# For each directory within the current directory, if the directory is a Git
# repository then execute the supplied function
function git-for-each-repo() {
    setopt local_options glob_dots
    for fnam in *(N/); do
        if [[ -d $fnam ]]; then
            pushd "$fnam" > /dev/null || return 1
            if git rev-parse --git-dir > /dev/null 2>&1; then
                "$@"
            fi
            popd > /dev/null || return 1
        fi
    done
}

# For each directory within the current directory, if the directory is a Git
# repository then execute the supplied function in parallel
function git-for-each-repo-parallel() {
    local dirs=$(find . -maxdepth 1 -type d)

    echo "$dirs" \
        | env_parallel --env "$1" -j10 \
            "
            pushd {} > /dev/null;                               \
            if git rev-parse --git-dir > /dev/null 2>&1; then   \
                $@;                                             \
            fi;                                                 \
            popd > /dev/null;                                   \
            "
}

# For each repo within the current directory, pull the repo
function git-repos-pull() {
    pull-repo() {
        echo "Pulling $(basename $PWD)"
        git pull -r --autostash
        echo
    }

    git-for-each-repo-parallel pull-repo
    git-repos-status
}

function git-repos-change-remote() {
    pull-repo() {
        local oldRemote=$(git remote -v | grep '(fetch)' | gsed -r 's/.*(git@github.*) .*/\1/g')
        #local newRemote=$(echo ${oldRemote} | gsed -r 's/-work/.com/g')
        local newRemote=$(echo ${oldRemote} | gsed -r 's/.com/-work/g')
        git remote remove origin
        git remote add origin ${newRemote}
        echo git remote add origin ${newRemote}
    }

    git-for-each-repo-parallel pull-repo
    git-repos-status
}


# For each repo within the current directory, fetch the repo
function git-repos-fetch() {
    local args=$*

    fetch-repo() {
        echo "Fetching $(basename $PWD)"
        git fetch ${args}
        echo
    }

    git-for-each-repo-parallel fetch-repo
    git-repos-status
}

# Parse Git status into a Zsh associative array
function git-parse-repo-status() {
    local aheadAndBehind
    local ahead=0
    local behind=0
    local added=0
    local modified=0
    local deleted=0
    local renamed=0
    local untracked=0
    local stashed=0

    branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
    ([[ $? -ne 0 ]] || [[ -z "$branch" ]]) && branch="unknown"

    aheadAndBehind=$(git status --porcelain=v1 --branch | perl -ne '/\[(.+)\]/ && print $1' )
    ahead=$(echo $aheadAndBehind | perl -ne '/ahead (\d+)/ && print $1' )
    [[ -z "$ahead" ]] && ahead=0
    behind=$(echo $aheadAndBehind | perl -ne '/behind (\d+)/ && print $1' )
    [[ -z "$behind" ]] && behind=0

    # See https://git-scm.com/docs/git-status for output format
    while read -r line; do
      # echo "$line"
      echo "$line" | gsed -r '/^[A][MD]? .*/!{q1}'   > /dev/null && (( added++ ))
      echo "$line" | gsed -r '/^[M][MD]? .*/!{q1}'   > /dev/null && (( modified++ ))
      echo "$line" | gsed -r '/^[D][RCDU]? .*/!{q1}' > /dev/null && (( deleted++ ))
      echo "$line" | gsed -r '/^[R][MD]? .*/!{q1}'   > /dev/null && (( renamed++ ))
      echo "$line" | gsed -r '/^[\?][\?] .*/!{q1}'   > /dev/null && (( untracked++ ))
    done < <(git status --porcelain)

    stashed=$(git stash list | wc -l)

    unset gitRepoStatus
    typeset -gA gitRepoStatus
    gitRepoStatus[branch]=$branch
    gitRepoStatus[ahead]=$ahead
    gitRepoStatus[behind]=$behind
    gitRepoStatus[added]=$added
    gitRepoStatus[modified]=$modified
    gitRepoStatus[deleted]=$deleted
    gitRepoStatus[renamed]=$renamed
    gitRepoStatus[untracked]=$untracked
    gitRepoStatus[stashed]=$stashed
}

# For each repo within the current directory, display the respository status
function git-repos-status() {
    display-status() {
        git-parse-repo-status
        repo=$(basename $PWD)

        local branchColor="${COLOR_RED}"
        if [[ "$gitRepoStatus[branch]" =~ (^\(main\|master\)$) ]]; then
            branchColor="${COLOR_GREEN}"
        fi
        local branch="${branchColor}$gitRepoStatus[branch]${COLOR_NONE}"

        local sync="${COLOR_GREEN}in-sync${COLOR_NONE}"
        if (( $gitRepoStatus[ahead] > 0 )) && (( $gitRepoStatus[behind] > 0 )); then
            sync="${COLOR_RED}ahead/behind${COLOR_NONE}"
        elif (( $gitRepoStatus[ahead] > 0 )); then
            sync="${COLOR_RED}ahead${COLOR_NONE}"
        elif (( $gitRepoStatus[behind] > 0 )); then
            sync="${COLOR_RED}behind${COLOR_NONE}"
        fi

        local dirty="${COLOR_GREEN}clean${COLOR_NONE}"
        (($gitRepoStatus[added] + $gitRepoStatus[modified] + $gitRepoStatus[deleted] + $gitRepoStatus[renamed] > 0)) && dirty="${COLOR_RED}dirty${COLOR_NONE}"

        print "${branch},${sync},${dirty},${repo}\n"
    }

    git-for-each-repo display-status | column -t -s ','
}

# For each repo within the current directory, display whether the repo contains
# unmerged branches locally
function git-repos-unmerged-branches() {
    display-unmerged-branches() {
        local cmd="git unmerged-branches"
        unmergedBranches=$(eval "$cmd")
        if [[ $unmergedBranches = *[![:space:]]* ]]; then
            echo "$fnam"
            eval "$cmd"
            echo
        fi
    }

    git-for-each-repo display-unmerged-branches
}

# For each repo within the current directory, display whether the repo contains
# unmerged branches locally and remote
function git-repos-unmerged-branches-all() {
    display-unmerged-branches-all() {
        local cmd="git unmerged-branches-all"
        unmergedBranches=$(eval "$cmd")
        if [[ $unmergedBranches = *[![:space:]]* ]]; then
            echo "$fnam"
            eval "$cmd"
            echo
        fi
    }

    git-for-each-repo display-unmerged-branches-all
}

# For each repo within the current directory, display whether the repo contains
# unmerged branches locally and remote in pretty form
function git-repos-unmerged-branches-all-pretty() {
    display-unmerged-branches-all-pretty() {

        # Handle legacy repos with trunks named 'master'
        if [[ ${inferTrunk} -eq 1 ]]; then
            if [[ -z $(git ls-remote --heads origin main 2>/dev/null) ]]; then
                export GIT_TRUNK=master
            else
                export GIT_TRUNK=main
            fi
        fi

        local cmd="git unmerged-branches-allv"
        unmergedBranches=$(eval "$cmd")
        if [[ $unmergedBranches = *[![:space:]]* ]]; then
            echo "$fnam"
            eval "$cmd"
            echo
        fi
    }

    if [[ $# -eq 1 ]]; then
        if [[ $1 == '--infer-trunk' ]]; then
            local inferTrunk=1
        else
            echo 'Usage: git-repos-unmerged-branches-all-pretty [--infer-trunk]'
            return 1
        fi
    fi

    local originalGitTrunk="${GIT_TRUNK}"

    git-for-each-repo display-unmerged-branches-all-pretty

    export GIT_TRUNK=${originalGitTrunk}
}
compdef "_arguments \
    '1:flags arg:(--infer-trunk)'" \
    git-repos-unmerged-branches-all-pretty

# For each repo within the current directory, display stashes
function git-repos-code-stashes() {
    stashes() {
        local cmd="git stash list"
        local output=$(eval "$cmd")
        if [[ $output = *[![:space:]]* ]]; then
            pwd
            eval "$cmd"
            echo
        fi
    }

    git-for-each-repo stashes
}

# For each repo within the current directory, display recent changes in the
# repo
function git-repos-recent() {
    recent() {
        local cmd='git --no-pager log-recent --perl-regexp --author="^((?!Jenkins).*)$" --invert-grep'
        local output=$(eval "$cmd")
        if [[ $output = *[![:space:]]* ]]; then
            pwd
            eval "$cmd"
            echo
            echo
        fi
    }

    git-for-each-repo recent
}

# For each repo within the current directory, check out the repo for the specified date
function git-repos-checkout-by-date() {
    local date="${1}"

    checkout-by-date() {
        git rev-list -n 1 --before="${date}" origin/main | xargs -I{} git checkout {}
    }

    git-for-each-repo checkout-by-date
}

# For each repo within the current directory, check out trunk
function git-repos-checkout-trunk() {
    local trunk="main"

    checkout-trunk() {
        git checkout "${trunk}"
    }

    git-for-each-repo checkout-trunk
}


# For each repo within the current directory, grep for the argument in the
# history
function git-repos-grep-history() {
    local str=$1

    check-history() {
        local str="$1"
        pwd
        git grep "${str}" $(git rev-list --all | tac)
        echo
    }

    git-for-each-repo-parallel check-history '"'"${str}"'"'
}

# For each repo within the current directory, show the number of lines per
# author
function git-repos-author-line-count() {
    author-line-count() {
        git ls-files \
            | xargs -n1 git blame -w -M -C -C --line-porcelain \
            | sed -n 's/^author //p'
    }

    git-for-each-repo author-line-count | sort -f | uniq -ic | sort -nr
}

# For each repo within the current directory, show the contribution commits per
# author
function git-repos-contributor-stats() {
    contributor-stats() {
        git --no-pager log --format="%aN" --no-merges
    }

    git-for-each-repo contributor-stats | sort | uniq -c | sort -r
}

# Build a list of authors for all repos within the current directory
function git-repos-authors() {
    authors() {
        git --no-pager log | grep "^Author:" | sort | uniq
    }

    git-for-each-repo authors \
        | gsed 's/Author: //' \
        | gsed -r 's/|(\S+), (.+)\([^<]+\)/\2\1/' \
        | sort \
        | uniq
}

# For each repo within the current directory, list the remote
function git-repos-remotes() {
    remotes() {
        git remote -v | grep '(fetch)' | gawk '{ print $2 }'
    }

    git-for-each-repo remotes
}

# For each directory within the current directory, generate a hacky count of
# lines of code files
function git-repos-hacky-line-count() {
    display-hacky-line-count() {
        lineCount=$(git ls-files | grep -e '\.\(scala\|py\|go\|java\|js\|ts\|sql\)$' | xargs -I{} cat {} | wc -l)
        echo "$fnam $lineCount"
    }

    git-for-each-repo display-hacky-line-count | column -t -s ' ' | sort -b -k 2.1 -n --reverse
}

# For each directory within the current directory, generate a hacky count of
# test and source files
function git-repos-hacky-test-count() {
    display-hacky-test-count() {
        tstCount=$(git ls-files | grep -e '\.\(scala\|py\|go\|java\|js\|ts\|sql\)$' | grep -ie  '.*test.*\.\(scala\|py\|go\|java\|js\|ts\|sql\)$' | wc -l)
        srcCount=$(git ls-files | grep -e '\.\(scala\|py\|go\|java\|js\|ts\|sql\)$' | grep -ive '.*test.*\.\(scala\|py\|go\|java\|js\|ts\|sql\)$' | wc -l)
        echo "$fnam $srcCount $tstCount"
    }

    git-for-each-repo display-hacky-test-count | sort -b -k 2.1 -n --reverse | prepend 'repo src tst' | column -t -s ' ' 
}

# Display remote branches which have been merged
function git-merged-branches() {
    git branch -r | xargs -t -n 1 git branch -r --contains
}

# Open the Git repo in the browser
#   Open repo: git-open
#   Open file: git-open foo/bar/baz.txt
function git-open() {
    local filename=$1

    local pathInRepo
    if [[ -n "${filename}" ]]; then
        pushd $(dirname "${filename}")
        pathInRepo=$(git ls-tree --full-name --name-only HEAD $(basename "${filename}"))
    fi

    local branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
    ([[ $? -ne 0 ]] || [[ -z "$branch" ]]) && branch="main"

    URL=$(git config remote.origin.url)
    echo "Opening '$URL'"

    if [[ $URL =~ ^git@ ]]; then
        [[ -n "${pathInRepo}" ]] && pathInRepo="tree/${branch}/${pathInRepo}"

        local hostAlias=$(echo "$URL" | sed -E "s|git@(.*):(.*).git|\1|")
        local hostname=$(ssh -G "${hostAlias}" | gawk '$1 == "hostname" { print $2 }')

        echo "$URL" \
            | sed -E "s|git@(.*):(.*).git|https://${hostname}/\2/${pathInRepo}|" \
            | xargs open

    elif [[ $URL =~ ^https://bitbucket.org ]]; then
        echo "$URL" \
            | sed -E "s|(.*).git|\1/src/${branch}/${pathInRepo}|" \
            | xargs open

    elif [[ $URL =~ ^https://github.com ]]; then
        [[ -n "${pathInRepo}" ]] && pathInRepo="tree/${branch}/${pathInRepo}"
        echo "$URL" \
            | sed -E "s|(.*).git|\1/${pathInRepo}|" \
            | xargs open

    else
        echo "Failed to open due to unrecognised URL '$URL'"
    fi

    [[ -n "${filename}" ]] && popd > /dev/null 2>&1
}

# Archive the Git branch by tagging then deleting it
function git-archive-branch() {
    if [[ $# -ne 1 ]] ; then
        echo 'Usage: git-archive-branch BRANCH'
        return 1
    fi

    # git tag archive/$1 $1
    git branch -D $1
}
compdef '_alternative \
  "arguments:custom arg:($(git branch --no-merged ${GIT_TRUNK}))" \
  ' \
  git-archive-branch

# Display the size of objects in the Git log
# https://stackoverflow.com/a/42544963
function git-large-objects() {
    git rev-list --objects --all \
        | git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' \
        | sed -n 's/^blob //p' \
        | sort --numeric-sort --key=2 \
        | cut -c 1-12,41- \
        | $(command -v gnumfmt || echo numfmt) --field=2 --to=iec-i --suffix=B --padding=7 --round=nearest
    }

# Rebase the current branch on trunk
function git-rebase-branch-on-trunk() {
    local trunk

    if [ -z "${GIT_TRUNK}" ] ; then
        trunk='main'
    else
        trunk="${GIT_TRUNK}"
    fi

    echo "Rebasing branch on ${trunk}"
    git rebase ${trunk}
}

# Rebase the current branch on trunk and squash the commits
function git-rebase-branch-on-trunk-and-squash-commits() {
    local trunk

    if [ -z "${GIT_TRUNK}" ] ; then
        trunk='main'
    else
        trunk="${GIT_TRUNK}"
    fi

    echo "Rebasing branch on ${trunk} and squashing commits"
    git rebase -i ${trunk}
}

# Display the meaning of characters used for the prompt markers
function git-prompt-help() {
    # TODO: Would be neater to do this dynamically based on info_format
    #       https://github.com/sorin-ionescu/prezto/blob/master/modules/git/functions/git-info
    local promptKey="
    ✚ added
    ⬆ ahead
    ⬇ behind
    ✖ deleted
    ✱ modified
    ➜ renamed
    ✭ stashed
    ═ unmerged
    ◼ untracked
    "
    echo $promptKey
}

function git-update-projects() {
    local projects=(
        ~/dev/kd/butter-chicken
        #~/dev/kd/misc
        ~/dev/kd/recs 
        #~/dev/kd/spirograph
        #~/dev/rdp/architecture
        ~/dev/rdp/concept 
        ~/dev/rdp/consumption
        ~/dev/rdp/core
        ~/dev/rdp/dkp 
        ~/dev/rdp/foundations
        #~/dev/rdp/scibite
    )

    for project in "${projects[@]}"
    do
        pushd ${project}       && git-repos-pull && git-repos-generate-stats && popd
        pushd ${project}/infra && git-repos-pull && git-repos-generate-stats && popd
    done
}

function git-repos-list-prs() {
    list-prs() {
        local output=$(PAGER='' gh pr list --json title,author,headRefName,createdAt)
        if [[ "${output}" != "[]" ]]; then
            echo "$(basename $PWD)"
            echo "${output}" | jq -r '["title", "author", "branch", "created"], (.[] | [.title, .author.login, .headRefName, .createdAt]) | @tsv' | column -t -s $'\t'
            echo
        fi
    }

    git-for-each-repo list-prs
}

function gh-pr () {
    PR_LIST=$(gh pr list --head "$(git branch --show-current)" --json number,title,url,baseRefName,closed,createdAt,latestReviews)
    PR_COUNT=$(echo "$PR_LIST" | jq '. | length')

    if [ "$PR_COUNT" -gt 0 ]; then
        FILTERED_PR_LIST=$(echo "$PR_LIST" | jq '[.[] | select(.closed == false)] | sort_by(.createdAt) | reverse')
        
        # TODO: prettify the output table
        echo -e "ID\tTITLE\tURL\tBASE BRANCH\tCREATED AT"
        echo "$FILTERED_PR_LIST" | jq -r '.[] | [.number, .title, .url, .baseRefName, .createdAt] | @tsv' | while IFS=$'\t' read -r number title url baseRefName createdAt; do
        relative_created_at=$(relative-time "$createdAt")
        printf "%s\t%s\t%s\t%s\t%s\t%s\n" "$number" "$title" "$url" "$baseRefName" "$relative_created_at"
        done | column -t -s $'\t'
        # echo "$PR_LIST" | jq -r '.[] | [.number, .title, .url, .baseRefName, .closed, (.createdAt | relative-time), .latestReviews] | @tsv' | column -t -s $'\t'
    else
        echo "No pull requests found."
    fi
}

function gh-open-prs-mine () {
    # Define the organization and author
    ORG="elsevier-research"
    AUTHOR="JerryYang42"

    # Get the current date and subtract 6 months
    SIX_MONTHS_AGO=$(date -v -6m +"%Y-%m-%dT%H:%M:%SZ")

    # Fetch the PRs using GitHub GraphQL API
    response=$(curl --silent --request POST \
    --url https://api.github.com/graphql \
    --header "Authorization: bearer $GITHUB_TOKEN" \
    --header 'User-Agent: zsh-script' \
    --data "{\"query\":\"{ search(query: \\\"org:$ORG author:$AUTHOR is:pr is:open\\\", type: ISSUE, first: 100) { edges { node { ... on PullRequest { title url createdAt updatedAt repository { name url } } } } } }\"}")

    # Parse and filter the JSON response
    echo "Updated At\t\tTITLE\t\tURL"
    echo "$response" | jq -r --arg date "$SIX_MONTHS_AGO" '
        .data.search.edges
        | map(select(.node.updatedAt > $date))
        | sort_by(.node.updatedAt)
        | reverse
        | .[]
        | "\(.node.updatedAt) --> \(.node.title) --> \(.node.url)"
    ' | awk '{
        cmd = "ddiff " $1 " now -f %S"
        cmd | getline diff_time
        close(cmd)
        
        # Convert the difference to a human-readable format
        if (diff_time < 60) {
            rel_time = diff " seconds ago"
        } else if (diff_time < 3600) {
            rel_time = int(diff / 60) " minutes ago"
        } else if (diff_time < 86400) {
            rel_time = int(diff_time / 3600) " hours ago"
        } else {
            rel_time = int(diff_time / 86400) " days ago"
        }
        
        $1 = rel_time
        print
    }'
}



# Git stats                         {{{2
# ======================================

# Generate CSV data about a Git repo
function git-generate-stats() {
    local awkScript

    # Use ASCII unit separator character "^_" as a separator

    # Generate hash-to-file mapping
    hashToFileCsvFilename=dataset-hash-to-file.csv
 
    read-heredoc awkScript <<'HEREDOC'
    {
        loc = match($0, /^[a-f0-9]{40}$/)
        if (loc != 0) {
            hash = substr($0, RSTART, RLENGTH)
        }
        else {
            if (match($0, /^$/) == 0) {
                print hash "" $0
            }
        }
    }
HEREDOC

    echo 'hashfile' > "${hashToFileCsvFilename}"
    git --no-pager log --format='%H' --name-only \
        | gawk "${awkScript}" \
        >> "${hashToFileCsvFilename}"

    # Generate hash-to-author mapping
    hashToAuthorCsvFilename=dataset-hash-to-author.csv

    local repoName=$(pwd | xargs basename)

    echo 'hashauthorrepo_namecommit_datecomment' > "${hashToAuthorCsvFilename}"
    git --no-pager log --format="%H%aN${repoName}%cI'%s'" \
        >> "${hashToAuthorCsvFilename}"

    # Join on hash to extract the full data
    local sqlScript
    read-heredoc sqlScript <<HEREDOC
        SELECT cf.hash, file, author, repo_name, commit_date, comment
        FROM read_csv('${hashToFileCsvFilename}', delim='') cf INNER JOIN read_csv('${hashToAuthorCsvFilename}', delim='') ca
        ON ca.hash = cf.hash
HEREDOC

    duckdb -csv -c "${sqlScript}" \
        > .git-stats.csv

    rm "${hashToAuthorCsvFilename}" "${hashToFileCsvFilename}"
}

# Merge CSV data about a Git repo
function git-stats-merge-files() {
    local fnam=".git-stats.csv"

    rm "./${fnam}"

    for f in $(gfind . -name ${fnam}); do
        echo "Merging ${f} into ${fnam}"

        if [[ -f "./${fnam}" ]]; then
            cat "${f}" | tail -n +2 >> "./${fnam}"
        else
            cat "${f}" > "./${fnam}"
        fi
    done
}

# For each repo within the current directory, generate statistics and merge the files
function git-repos-generate-stats() {
    stats() {
        echo "Getting stats for $(basename $PWD)"
        git-generate-stats

        local fnam=".git-stats.csv"

        if [[ -f "../${fnam}" ]]; then
            cat "${fnam}" | tail -n +2 >> "../${fnam}"
        else
            cat "${fnam}" > "../${fnam}"
        fi

        rm "${fnam}"
    }

    rm -f ".git-stats.csv"

    git-for-each-repo stats
}

# For each repo within the current directory, track all branches
function git-repos-track-and-pull-all() {
    track-and-pull-all() {
        echo "Tracking all branches for $(basename $PWD)"
        git track-all
        git fetch --all
        git pull --all
        echo
    }

    git-for-each-repo track-and-pull-all
}

# For each repo within the current directory, extact the authors and diff with mailmap
function git-mailmap-update() {
    git-repos-authors > .authors.txt
    vim -d .authors.txt ~/.mailmap
}

# For the Git stats in the current directory, display who on the team knows most about a repo
function git-stats-top-team-committers-by-repo() {
    if [[ $# -ne 1 ]] ; then
        echo 'Usage: git-stats-top-team-committers-by-repo TEAM'
        return 1
    fi

    local team=$1
    [ "${team}" = 'recs' ]               && teamMembers="'Anamaria Mocanu', 'Rich Lyne', 'Reinder Verlinde', 'Tess Hoad', 'Luci Curnow', 'Andy Nguyen', 'Jerry Yang'"
    [ "${team}" = 'recs-extended' ]      && teamMembers="'Anamaria Mocanu', 'Rich Lyne', 'Reinder Verlinde', 'Tess Hoad', 'Luci Curnow', 'Andy Nguyen', 'Jerry Yang', 'Stu White', 'Dimi Alexiou', 'Ligia Stan'"
    [ "${team}" = 'butter-chicken' ]     && teamMembers="'Asmaa Shoala', 'Carmen Mester', 'Colin Zhang', 'Hamid Haghayegh', 'Henry Cleland', 'Karthik Jaganathan', 'Krishna', 'Rama Sane'"
    [ "${team}" = 'spirograph' ]         && teamMembers="'Paul Meyrick', 'Fraser Reid', 'Nancy Goyal', 'Richard Snoad', 'Ayce Keskinege'"
    [ "${team}" = 'dkp-legacy' ]         && teamMembers="'Ryan Moquin', 'Gautam Chakrabarty', 'Prakruthy Dhoopa Harish', 'Arun Kumar Kalahastri', 'Sangavi Durairaj', 'Vidhya Shaghar A P', 'Suganya Moorthy', 'Chinar Jaiswal'"
    [ "${team}" = 'dkp' ]                && teamMembers="'Prakruthy Dhoopa Harish', 'Arun Kumar Kalahastri', 'Sangavi Durairaj', 'Vidhya Shaghar A P', 'Suganya Moorthy', 'Chinar Jaiswal'"
    [ "${team}" = 'foundations' ]        && teamMembers="'Adrian Musial', 'Alex Harris', 'Prasann Grampurohit', 'Syeeda Banu C', 'Ashish Wakchaure', 'Pavel Ryzhov', 'Sachin Kumar', 'Shantanu Sinha', 'Prasanth Rave', 'Pavel Kashmin'"
    [ "${team}" = 'consumption' ]        && teamMembers="'Nitin Dumbre', 'Narasimha Reddybhumireddygari', 'Delia Bute', 'Mustafa Toplu', 'Talvinder Matharu', 'Bikramjit Singh', 'Harprit Singh', 'Parimala Balaraju'"
    [ "${team}" = 'concept' ]            && teamMembers="'Saad Rashid', 'Adam Ladly', 'Jeremy Scadding', 'Nishant Singh', 'Neil Stevens', 'Dominicano Luciano', 'Kanaga Ganesan', 'Akhil Babu', 'Gintautas Sulskus'"
    [ "${team}" = 'concept-extended' ]   && teamMembers="'Saad Rashid', 'Benoit Pasquereau', 'Adam Ladly', 'Jeremy Scadding', 'Anique von Berne', 'Nishant Singh', 'Neil Stevens', 'Dominicano Luciano', 'Kanaga Ganesan', 'Akhil Babu', 'Gintautas Sulskus'"
    [ "${team}" = 'scibite-centree' ]    && teamMembers="'Simon Jupp', 'Olivier Feller', 'Barry Wilks', 'Georgianna Dumitraica', 'Blessan Kunjumon', 'Tim Medcalf', 'Mohammad Haroon'"
    [ "${team}" = 'scibite-search' ]     && teamMembers="'Phil Verdemato', 'Andrew Cowley', 'Rob Martin', 'David Styles', 'Alex Biddle', 'Kieran Whiteman', 'Svetlana Taneva'"
    [ "${team}" = 'scibite-ai' ]         && teamMembers="'Brandon Walts', 'Mark McDowall', 'Oliver Giles', 'Olivia Watson'"
    [ "${team}" = 'scibite-termite-6' ]  && teamMembers="'Phil Verdemato', 'Thales Valias', 'Petar Yordanov'"
    [ "${team}" = 'scibite-termite-7' ]  && teamMembers="'Phil Vermedmato', 'Pedro Morais', 'Antonis Loizou', 'Fernando Almeida', 'Thales Valias', 'Kieran Whiteman', 'Petar Yordanov'"
    [ "${team}" = 'scibite-workbench' ]  && teamMembers="'Simon Jupp', 'Santhi Nalukurthy', 'Alex Biddle', 'Ali Raza'"
    [ "${team}" = 'scibite-ontologies' ] && teamMembers="'Jane Lomax', 'Rebecca Foulger', 'Mark McDowall'"
    [ "${team}" = 'scibite-ds' ]         && teamMembers="'Michael Huges', 'Maaly Nasar', 'Zahra Hosseini'"

    echo
    echo 'Team'
    while read teamMember
    do
        echo $teamMember
    done < <(echo ${teamMembers} | gsed 's/, /\n/g' | gsed "s/'//g" | sort)

    echo
    echo 'Repos with authors in the team'
    read-heredoc sqlScript <<HEREDOC
        |.mode columns
        |select repo_name, author, total from (
        |   select *, row_number() over (partition by repo_name order by total desc) as rank 
        |   from (
        |      select repo_name, author, count(*) as total
        |      from '.git-stats.csv' 
        |      where author in (${teamMembers})
        |      group by (repo_name, author)
        |   ) d
        |) e
        |where rank <= 5
        |order by repo_name, rank;
HEREDOC

    print ${sqlScript} | gsed 's/^ \+|//' > .script
    duckdb < .script
    rm .script
}
compdef "_arguments \
    '1:team arg:(recs recs-extended butter-chicken foundations spirograph dkp dkp-legacy concept concept-extended consumption scibite-ai scibite-centree scibite-ds scibite-ontologies scibite-search scibite-termite-6 scibite-termite-7 scibite-workbench)'" \
    git-stats-top-team-committers-by-repo
    
# For the Git stats in the current directory, display all authors
function git-stats-authors() {
    local sqlScript
    read-heredoc sqlScript <<HEREDOC
        |.mode columns
        |select distinct author 
        |from '.git-stats.csv' order by author asc;
HEREDOC

    print ${sqlScript} | gsed 's/^ \+|//' > .script
    duckdb < .script
    rm .script
}

# For the Git stats in the current directory, display the most recent commits
# by each author
function git-stats-most-recent-commits-by-authors() {
    local sqlScript
    read-heredoc sqlScript <<HEREDOC
        |.mode columns
        |select commit_date, author from (
        |    select max(commit_date) as commit_date, author 
        |    from '.git-stats.csv' group by author
        |) d 
        |order by commit_date desc;
HEREDOC

    print ${sqlScript} | gsed 's/^ \+|//' > .script
    duckdb < .script
    rm .script
}

# For the Git stats in the current directory, display the total number of
# commits by each author
function git-stats-total-commits-by-author() {
    if [[ $# -ne 1 ]] ; then
        echo 'Usage: git-stats-total-commits-by-author AUTHOR'
        return 1
    fi

    local authorName=$1

    local sqlScript
    read-heredoc sqlScript <<HEREDOC
        |.mode columns
        |select repo_name, total from (
        |    select repo_name, author, count(*) as total 
        |    from '.git-stats.csv' group by repo_name, author
        |) d
        |where author = '${authorName}'
HEREDOC

    print ${sqlScript} | gsed 's/^ \+|//' > .script
    duckdb < .script
    rm .script
}

# For the Git stats in the current directory, list the commits
function git-stats-list-commits() {
    local sqlScript
    read-heredoc sqlScript <<HEREDOC
        |.mode columns
        |select distinct repo_name, commit_date, comment
        |from '.git-stats.csv' 
        |order by commit_date desc
HEREDOC

    print ${sqlScript} | gsed 's/^ \+|//' > .script
    duckdb < .script
    rm .script
}

# For the Git stats in the current directory, list the author commits in the last week
function git-stats-list-author-commits-in-n-days() {
    if [[ $# -ne 1 ]] ; then
        echo 'Usage: git-stats-list-author commits-in-n-days N'
        return 1
    fi

    local numDays=$1

    local sqlScript
    read-heredoc sqlScript <<HEREDOC
        |.mode columns
        |select distinct repo_name, author, commit_date, comment
        |from '.git-stats.csv' 
        |where date_diff('day', commit_date, current_date) <= ${numDays}
        |  and author not in ('Jenkins')
        |order by commit_date desc
HEREDOC

    print ${sqlScript} | gsed 's/^ \+|//' > .script
    duckdb < .script
    rm .script
}


# For the Git stats in the current directory, list the commits for a given author
function git-stats-list-commits-by-author() {
    if [[ $# -ne 1 ]] ; then
        echo 'Usage: git-stats-list-commits-by-author AUTHOR'
        return 1
    fi

    local authorName=$1

    local sqlScript
    read-heredoc sqlScript <<HEREDOC
        |.mode columns
        |select distinct repo_name, commit_date, comment
        |from '.git-stats.csv' 
        |where author = '${authorName}'
        |order by commit_date desc
HEREDOC

    print ${sqlScript} | gsed 's/^ \+|//' > .script
    duckdb < .script
    rm .script
}

# For the Git stats in the current directory, list the commits for a given
# author by month
function git-stats-total-commits-by-author-per-month() {
    if [[ $# -ne 1 ]] ; then
        echo 'Usage: git-stats-total-commits-by-author-per-month AUTHOR'
        return 1
    fi

    local authorName=$1

    local sqlScript
    read-heredoc sqlScript <<HEREDOC
        |.mode columns
        |select strftime('%Y-%m', commit_date) as 'year_month', count(*) as total from (
        |    select distinct repo_name, commit_date, comment
        |    from '.git-stats.csv' 
        |    where author = '${authorName}'
        |) d
        |group by year_month order by year_month desc
HEREDOC

    print ${sqlScript} | gsed 's/^ \+|//' > .script
    duckdb < .script
    rm .script
}

# For the Git stats in the current directory, list the most recent commits for
# each repo
function git-stats-most-recent-commits-by-repo() {
    local sqlScript
    read-heredoc sqlScript <<HEREDOC
        |.mode columns
        |select max(commit_date) as last_commit, repo_name
        |from '.git-stats.csv' where file not in ('version.sbt')
        |group by repo_name order by last_commit desc
HEREDOC

    print ${sqlScript} | gsed 's/^ \+|//' > .script
    duckdb < .script
    rm .script
}

# GitHub                            {{{2
# ======================================

# Notify me when my GitHub PR has been reviewed
function github-notify-when-reviewed() {
    {
        while true
        do
            sleep 30
            (github-list-pull-requests | grep -v 'Pull requests for' | grep -q -R '\(has-reviews\|has-comments\)') && break
        done

        if (github-list-pull-requests | grep -v 'Pull requests for' | grep -q -R '\(has-reviews\|has-comments\)') ; then
            tell-me "GitHub PR reviewed or commented on"
        fi
    } > /dev/null 2>&1 & disown
}

# Notify me when my GitHub PR has changed
function github-notify-on-change() {
    f() {
        github-list-pull-requests
    }

    notify-on-change f 30 'GitHub PR changed'
}

function github-list-user-repos() {
    if [[ $# -ne 1 ]] ; then
        echo 'Usage: github-list-user-repos USERNAME'
        return -1
    fi

    local user=$1
    local base_url="https://api.github.com:443/users/${user}/repos"

    # Get user email and token, for which we unfortunately need a repo
    local tmpDir=$(mktemp -d "${TMPDIR:-/tmp}"/github-list-user-repos.XXXX)
    pushd ${tmpDir} > /dev/null
    git init > /dev/null

    local token=$(git config --get user.token)
    local email=$(git config --get user.email)

    popd > /dev/null
    rm -rf ${tmpDir}

    # Page through repositories
    local page=1
    local results=''
    while : ;
    do
        local resultsPage=$(curl -u ${email}:${token} -s "${base_url}?per_page=100\&page=$page")
        [[ "$(echo "${resultsPage}" | jq 'isempty(.[])')" == "true" ]] && break
        results=$results$resultsPage
        page=$((page + 1))
    done

    echo ${results} \
        | jq -r '.[] | [ .pushed_at, .name ] | @csv' \
        | tabulate-by-comma \
        | sort -r \
        | strip-quotes
}

# Homebrew                          {{{2
# ======================================
export HOMEBREW_NO_ENV_HINTS=1

# Java                              {{{2
# ======================================

# https://www.zsh.org/mla/users/2011/msg00514.html

# Switch Java version
function java-version() {
    if [[ $# -ne 1 ]] ; then
        echo 'Usage: java-version JVM'
        return 1
    fi

    local NEW_JAVA_HOME=/Library/Java/JavaVirtualMachines/${1}/Contents/Home/

    if [[ -v JAVA_HOME ]]; then
        echo "Switching JAVA_HOME from ${JAVA_HOME} to ${NEW_JAVA_HOME}"
        export PATH=$(echo $PATH | sed "s|${JAVA_HOME}|${NEW_JAVA_HOME}|")
        export JAVA_HOME=${NEW_JAVA_HOME}
    else
        echo "Setting JAVA_HOME to ${NEW_JAVA_HOME}"
        export PATH=$PATH:${NEW_JAVA_HOME}
        export JAVA_HOME=${NEW_JAVA_HOME}
    fi
}
compdef _java-version java-version

_java-version() {          
  local -a installedJDKs
  installedJDKs=(/Library/Java/JavaVirtualMachines/)
  _files -/ -W installedJDKs -g '*'
}

function java-version-infer() {
    local currDir=$(pwd)

    case "${currDir}" in
        */recommenders|*/recommenders/*)
            java-version temurin-8.jdk/
        ;;

        */dkp|*/dkp/*)
            java-version temurin-17.jdk/
        ;;

        */rdp/sandbox|*/rdp/sandbox/*)
            java-version temurin-17.jdk/
        ;;

        *)
            echo "Unrecognised path ${currDir}, Java version unchanged "
        ;;
    esac

    java -version
}

# Default Java version
java-version temurin-17.jdk > /dev/null

# JIRA                              {{{2
# ======================================

function jira-my-issues() {
    curl -s -G 'https://elsevier.atlassian.net/rest/api/2/search' \
        --data-urlencode "jql=assignee = currentUser() AND status IN (\"In Progress\")" \
        --user "${SECRET_JIRA_USER}:${SECRET_JIRA_API_KEY}" \
        | jq -r ".issues[] | [.key, .fields.summary] | @tsv" \
        | tabulate-by-tab
}

# jq / xq                           {{{2
# ======================================

# Display the paths to the values in the JSON
# cat foo.json | jq-paths
function jq-paths() {
    # Taken from https://github.com/stedolan/jq/issues/243
    jq '[path(..)|map(if type=="number" then "[]" else tostring end)|join(".")|split(".[]")|join("[]")]|unique|map("."+.)|.[]'
}

# Display the paths to the values in the XML
# cat foo.xml | xq-paths
function xq-paths() {
    # Taken from https://github.com/stedolan/jq/issues/243
    xq '[path(..)|map(if type=="number" then "[]" else tostring end)|join(".")|split(".[]")|join("[]")]|unique|map("."+.)|.[]'
}

# KeePassXC                         {{{2
# ======================================

alias keepassxc='/Applications/KeePassXC.app/Contents/MacOS/KeePassXC --allow-screencapture &'

alias keepassxc-cli='/Applications/KeePassXC.app/Contents/MacOS/keepassxc-cli'

alias keepassxc-get-ssh='keepassxc-cli clip ~/Dropbox/Private/keepassx/personal.kdbx /Personal/SSH'

alias keepassxc-get-gpg='keepassxc-cli clip ~/Dropbox/Private/keepassx/elsevier.kdbx /Elsevier/GPG'

# Ripgrep                           {{{2
# ======================================

export RIPGREP_CONFIG_PATH=~/.ripgreprc

# SBT                               {{{2
# ======================================

alias sbt-no-test='sbt "set test in assembly := {}"'
alias sbt-test='sbt test it:test'
alias sbt-profile='sbt -Dsbt.task.timings=true'

# Shellcheck                        {{{2
# ======================================

export SHELLCHECK_OPTS=""
SHELLCHECK_OPTS+="-e SC1091 "    # Allow sourcing files from paths that do not exist yet
SHELLCHECK_OPTS+="-e SC2039 "    # Allow dash in function names
SHELLCHECK_OPTS+="-e SC2112 "    # Allow 'function' keyword
SHELLCHECK_OPTS+="-e SC2155 "    # Allow declare and assignment in the same statement
SHELLCHECK_OPTS+="-e SC3011 "    # Allow here-strings, not in POSIX sh
SHELLCHECK_OPTS+="-e SC3033 "    # Allow dashes in functionn names, not in POSIX sh
SHELLCHECK_OPTS+="-e SC3043 "    # Allow 'local', not in POSIX sh

# SSL certificates                  {{{2
# ======================================

function certificate-download() {
    if [[ $# -ne 1 ]] ; then
        echo 'Usage: certificate-download HOSTNAME'
        return 1
    fi

    local hostname=$1
    local certFile="$(echo ${hostname} | tr '.' '-')".crt

    echo "Downloading certificate to ${certFile}"
    openssl x509 -in <(openssl s_client -connect ${hostname}:443 -prexit 2>/dev/null) -out "./${certFile}"
}

function certificate-java-list() {
    local defaultPassword=changeit

    local rootPathsToCheck=(
        /Library
        /Applications/DBeaver.app
    )

    for rootPath in "${rootPathsToCheck[@]}"
    do
        local keystores=$(find ${rootPath} -name cacerts)
        while IFS= read -r keystore; do
            echo
            echo "${keystore}"
            local output=$(keytool -storepass ${defaultPassword} -keystore "${keystore}" -list)
            echo "${output}" | highlight blue '.*'
        done <<< "${keystores}"
    done
}

function certificate-java-install() {
    if [[ $# -ne 1 ]] ; then
        echo 'Usage: certificate-java-install FILE'
        echo
        echo 'Example:'
        echo 'certificate-java-install /Users/white1/dev/certificates/ZscalerRootCertificate-2048-SHA256.crt'
        echo 'Default keystore password is changeit'
        return 1
    fi

    local certFile=$1
    local certAlias=$(basename ${certFile})
    local defaultPassword=changeit

    local rootPathsToCheck=(
        /Library
        /Applications/DBeaver.app
    )

    for rootPath in "${rootPathsToCheck[@]}"
    do
        local keystores=$(find ${rootPath} -name cacerts)
        while IFS= read -r keystore; do
            echo
            echo "Checking ${keystore}"
            local output=$(keytool -storepass ${defaultPassword} -keystore "${keystore}" -list -alias ${certAlias})
            if [[ ${output} =~ 'trustedCertEntry' ]]; then
                msg-success "Certificate present"
            else
                msg-error "Certificate missing -- run the following to install"
                echo sudo keytool \
                    -storepass ${defaultPassword} \
                    -keystore "${keystore}" \
                    -importcert \
                    -file "${certFile}" \
                    -alias ${certAlias} \
                    -noprompt
            fi
        done <<< "${keystores}"
    done
}

function certificate-python-install() {
    if [[ $# -ne 1 ]] ; then
        echo 'Usage: certificate-python-install FILE'
        echo
        echo 'Example:'
        echo 'certificate-python-install /Users/white1/Dev/certificates/ZscalerRootCertificate-2048-SHA256.crt'
        return 1
    fi

    local certFile=$1
    local certAlias=$(basename ${certFile})
    for localCertFile in $(find . -name cacert.pem); do
            echo
            echo "Checking ${localCertFile}"
            local output=$(grep ${certAlias} ${localCertFile})
            if [[ ${output} =~ "${certAlias}" ]]; then
                msg-success "Certificate present"
            else
                msg-error "Certificate missing -- adding"
                echo ""                >> ${localCertFile}
                echo "# ${certAlias}"  >> ${localCertFile}
                cat ${certFile}        >> ${localCertFile}
            fi
    done
}

# function certificate-insinuate() {
#     if [[ $# -ne 1 ]] ; then
#         echo 'Usage: certificate-insinuate FILE'
#         echo
#         echo 'Example:'
#         echo 'certificate-insinuate CERTFIL'
#         return 1
#     fi
# 
#     local ZSCALER_CERT_FILE=/Users/white1/Dev/certificates/ZscalerRootCertificate-2048-SHA256.crt
#     local MARKER_STRING="zscaler-certificate"
# 
# 
#     while read -r certFile;
#     do
#         grep -i "${MARKER_STRING}" "${certFile}" > /dev/null
#         exitCode="$?"
#         if [[ $exitCode -eq 0 ]]; then
#             true
#         else
#             echo "Patching ${certFile} to include ZScaler certificate from ${ZSCALER_CERT_FILE}"
#             cat ${certFile} <(echo "${MARKER_STRING}") ${ZSCALER_CERT_FILE} > new-cert-file.pem
#             mv new-cert-file.pem ${certFile}
#         fi
#     done < <(find . -name *.pem)
# 
# }

function certificate-python-show-paths() {
    python -c "import ssl; print(ssl.get_default_verify_paths())" 
    echo "SSL_CERT_FILE: ${SSL_CERT_FILE}"
}

function certificate-expiry-curl() {
    if [[ $# -ne 1 ]] ; then
        echo 'Usage: certificate-expiry-curl HOSTNAME'
        return 1
    fi
    curl -Iv --stderr - "https://${1}" | grep "expire date"
}

function certificate-expiry-openssl() {
    if [[ $# -ne 1 ]] ; then
        echo 'Usage: certificate-expiry-openssl HOSTNAME'
        return 1
    fi
    echo Q | openssl s_client -connect "${1}":443 | openssl x509 -noout -dates
}

# Tmuxinator                        {{{2
# ======================================

source-if-exists "$HOME/Dev/my-stuff/dotfiles/tmuxinator/tmuxinator.zsh"

# Machine-specific configuration                                            {{{1
# ==============================================================================

if-linux && {
    source-if-exists "$HOME/.zshrc.linux"
}

if-darwin && {
    source-if-exists "$HOME/.zshrc.darwin"
}

source-if-exists "$HOME/.zshrc.$(scutil --get ComputerName)"

function camera-logs() {
    log show --last 5m --predicate '(sender == "VDCAssistant")' | grep kCameraStream
}

# Testing
# echo "$(greyscale 123) testing"
function greyscale() {
    local level=$1
    printf "\e[38;2;${level};${level};${level}m"
}

function days-between() {
    local date1=$1
    local date2=$2

    echo $(( ( $(date -d "${date2}" "+%s") - $(date -d "${date1}" "+%s") ) / 86400))
}

function age() {
    days-between $1 $(date --iso-8601=s)
}

colors () {
    for i in {0..255}
    do
        print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}
    done
}

