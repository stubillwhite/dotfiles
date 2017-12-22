# vim:fdm=marker

# Included scripts                                                          {{{1
# ==============================================================================

# Include common configuration
source $HOME/.common.sh

# Include completion functions
fpath=(~/.zsh-completion $fpath)
autoload -U compinit
compinit

# Include Prezto, but remove unhelpful configuration
source_if_exists "$HOME/.zprezto/init.zsh"
unalias cp &> /dev/null         # Standard behaviour
unalias rm &> /dev/null         # Standard behaviour
unalias mv &> /dev/null         # Standard behaviour
setopt clobber                  # Happily clobber files
setopt interactivecomments      # Allow comments in interactive shells
unsetopt AUTO_CD                # Don't change directory autmatically
unsetopt AUTO_PUSHD             # Don't push directory automatically

# AWS tools
source_if_exists "/usr/local/bin/aws_zsh_completer.sh"

# General options                                                           {{{1
# ==============================================================================

setopt BASH_REMATCH             # Bash regex support
setopt menu_complete            # Tab autocompletes first option even if ambiguous

# Aliases                                                                   {{{1
# ==============================================================================

# Helper aliases
alias assume-role='source ~/Dev/my-stuff/utils/assume-role.sh'
alias eject='diskutil eject'
alias env='env | sort'
alias tree='tree -A'
alias watch='watch -c'
alias ssh-purge-key='ssh-keygen -R'
alias vi='nvim'
alias vim='nvim'
alias files-show='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias files-hide='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'
alias python-env-activate='source env/bin/activate'

# SBT
export SBT_OPTS=-Xmx2G

# Specific tools                                                            {{{1
# ==============================================================================

# Shellcheck                        {{{2
# ======================================

export SHELLCHECK_OPTS=""
SHELLCHECK_OPTS+="-e SC1091 "    # Allow sourcing files from paths that do not exist yet
SHELLCHECK_OPTS+="-e SC2039 "    # Allow dash in function names
SHELLCHECK_OPTS+="-e SC2112 "    # Allow 'function' keyword

# General file helpers              {{{2
# ======================================

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
function tarf() {
    declare fnam=$1
    tar -zcvf ${fnam%/}.tar.gz $1
}

# Untar a file
function untarf() {
    declare fnam=$1
    tar -zxvf $1
}

# SSH tunneling                     {{{2
# ======================================

function tunnel-open() {
    if [[ $# -ne 4 ]] ; then
        echo 'Usage: tunnel-open LOCALPORT HOST HOSTPORT SERVER'
        return -1
    fi

    localPort=$1
    host=$2
    hostPort=$3
    server=$4
    connectionFile=~/.ssh-tunnel-localhost:${localPort}===${host:0:20}:${hostPort}

    echo "Opening tunnel localhost:${localPort} -> ${server} -> ${host}:${hostPort}"
    ssh -L ${localPort}:${host}:${hostPort} ${server} -f -o ServerAliveInterval=30 -N -M -S ${connectionFile} || { echo "Failed to open tunnel"; return -1; }
    echo "Tunnel open ${connectionFile}"
}
compdef _hosts tunnel-open

function tunnel-list() {
    ls ~/.ssh-tunnel-*
}

function tunnel-check() {
    if [[ $# -ne 1 ]] ; then
        echo 'Usage: tunnel-check CONNECTIONFILE'
        return -1
    fi
    connectionFile=$1

    [[ ${connectionFile} =~ .ssh-tunnel-localhost:(.*)===(.*):(.*) ]]

    localPort=${BASH_REMATCH[1]}
    host=${BASH_REMATCH[2]}
    hostPort=${BASH_REMATCH[3]}

    echo "Checking tunnel localhost:${localPort} -> ${host}:${hostPort}"
    ssh -S ${connectionFile} -O check ${host}
}
compdef '_files -g "~/.ssh-tunnel-*"' tunnel-check

function tunnel-close() {
    if [[ $# -ne 1 ]] ; then
        echo 'Usage: tunnel-close CONNECTIONFILE'
        return -1
    fi

    connectionFile=$1

    [[ ${connectionFile} =~ .ssh-tunnel-localhost:(.*)===(.*):(.*) ]]

    localPort=${BASH_REMATCH[1]}
    host=${BASH_REMATCH[2]}
    hostPort=${BASH_REMATCH[3]}

    echo "Closing tunnel localhost:${localPort} -> ${host}:${hostPort}"
    ssh -S ${connectionFile} -O exit ${host}
}
compdef '_files -g "~/.ssh-tunnel-*"' tunnel-close

function tunnel-close-all() {
    for connectionFile in ~/.ssh-tunnel-*
    do
        tunnel-close $connectionFile
    done
}

# AWS                               {{{2
# ======================================

function aws-instance-info() {
    if [[ $# -ne 3 ]] ; then
        echo 'Usage: aws-instance-info PROFILE REGION TAG'
        return 1
    fi

    local profile=$1
    local region=$2
    local tag=$3

    aws --profile $profile ec2 describe-instances --region $region | jq --raw-output '.Reservations[].Instances[]? | select(.Tags[].Value=="'$tag'") | select(.State.Name=="running")'
}
compdef _aws-tag aws-instance-info

# List the values of tagged AWS instances
function aws-tag-values() {
    if [[ $# -ne 3 ]] ; then
        echo 'Usage: aws-tag-values PROFILE REGION KEY'
        return 1
    fi

    local profile=$1
    local region=$2
    local key=$3
    
    aws --profile $profile ec2 describe-instances --region $region | jq --raw-output '.Reservations[].Instances[].Tags[]? | select(.Key=="'$key'") | .Value' | sort | uniq
}
compdef _aws-tag aws-tag-values

# List the IPs for tagged AWS instances
function aws-instance-ips() {
    if [[ $# -ne 3 ]] ; then
        echo 'Usage: aws-instance-ips PROFILE REGION TAG'
        return 1
    fi

    local profile=$1
    local region=$2
    local tag=$3

    aws --profile $profile ec2 describe-instances --region $region | jq --raw-output '.Reservations[].Instances[] | select(.Tags[]?.Value=="'$tag'") | select(.State.Name=="running") | .PrivateIpAddress' | sort | uniq
}
compdef _aws-tag aws-instance-ips

# SSH into tagged AWS instances
function aws-ssh() {
    if [[ $# -ne 3 ]] ; then
        echo 'Usage: aws-instance-ips PROFILE REGION TAG'
        return 1
    fi

    local profile=$1
    local region=$2
    local tag=$3

    local ip=$(aws-instance-ips $profile $region $tag)
    ssh $ip
}
compdef _aws-tag aws-ssh

# Fast AI course helpers            {{{2
# ======================================

function fast-ai-setup() {
    export PATH=~/anaconda/bin:$PATH
    export AWS_DEFAULT_PROFILE=stubillwhite
    source_if_exists "/Users/white1/Dev/my-stuff/fast-ai/courses/setup/aws-alias.sh"
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

# Executing scripts remotely        {{{2
# ======================================

function execute-on-remote-host() {
    if [[ $# -lt 2 ]] ; then
        echo 'Asynchronously execute a script on a remote host in a tmux session'
        echo 'Usage: execute-on-remote-host HOST SCRIPT [ARGS]'
        return -1
    fi

    remoteHost=$1
    scriptPath=$2
    shift
    shift
    args=$*

    scriptName=$(basename $scriptPath)
    sessionName=${scriptName%.*}

    echo
    echo "Copying $scriptPath to $remoteHost"
    echo scp $scriptPath $remoteHost:$scriptName
    scp $scriptPath $remoteHost:$scriptName

    echo
    echo "Connecting to machine and executing script under tmux session $sessionName"
    tmuxCmd="./$scriptName $args"
    sshCmd="tmux new -d -s $sessionName \"$tmuxCmd\""
    echo ssh -t $remoteHost "$sshCmd"
    ssh -t $remoteHost "$sshCmd"

    echo
    echo "To connect to the session"
    echo "  ssh $remoteHost"
    echo "  tmux attach -t $sessionName"
    echo "Note that the session will automatically close when the script terminates"
}

# Git                               {{{2
# ======================================

# For each directory within the current directory, display whether the
# directory is a dirty or clean Git repository
function git-modified-repos() {
    for fnam in *; do
        if [[ -d $fnam ]]; then
            pushd $fnam
            if git rev-parse --git-dir > /dev/null 2>&1; then
                if [[ `git status --porcelain --untracked-files=no` ]]; then
                    printf "${fnam} -- ${COLOR_RED}modified${COLOR_NONE}\n"
                else
                    printf "${fnam} -- ${COLOR_GREEN}clean${COLOR_NONE}\n"
                fi
            fi
            popd
        fi
    done
}

# For each directory within the current directory, display whether the
# directory is on master or a branch
function git-branched-repos() {
    for fnam in *; do
        if [[ -d $fnam ]]; then
            pushd $fnam
            if git rev-parse --git-dir > /dev/null 2>&1; then
                branchName=$(git rev-parse --abbrev-ref HEAD)
                if [[ $branchName == "master" ]]; then
                    printf "${fnam} -- ${COLOR_GREEN}${branchName}${COLOR_NONE}\n"
                else
                    printf "${fnam} -- ${COLOR_RED}${branchName}${COLOR_NONE}\n"
                fi
            fi
            popd
        fi
    done
}

# Open the git repo in the browser
function git-open() {
    URL=$(git config remote.origin.url)
    echo "Opening $URL"
    if [[ $URL =~ "git@" ]]; then
        echo $URL | sed -e 's/:/\//' | sed -e 's/git@/http:\/\//' | xargs open
    elif [[ $URL =~ "^https:" ]]; then
        echo $URL | xargs open
    else
        echo "Failed to open due to unrecognised URL $URL"
    fi
}

# Archive the Git branch by tagging then deleting it
function git-archive-branch() {
    if [[ $# -ne 1 ]] ; then
        echo 'Archive Git branch by tagging then deleting it'
        echo 'Usage: git-archive-branch BRANCH'
        return -1
    fi

    git tag archive/$1 $1
    git branch -D $1
}

# Display the meaning of characters used for the prompt markers
function prompt-help() {
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

# AWS

function plot-aws-s3-size() {
    if [[ $# -ne 3 ]] ; then
        echo 'Plot the size of the AWS S3 bucket and prefix'
        echo 'Usage: plot-aws-s3-size PROFILE PREFIX PERIOD'
        return -1
    fi

    profile=$1
    prefix=$2
    period=$3

    interval -t $period "aws --profile '$profile' s3 ls --summarize --recursive '$prefix' | grep 'Total Size' | awk '"'{ print $3 }'"'" | plot
}

function aws-export-current-credentials() {
    echo "export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} && export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}"
}

# Docker

function docker-remove-dangling-imgaes() {
    docker ps -a -q | xargs docker stop
    docker ps -a -q | xargs docker rm -v
    docker images -q | xargs docker rmi
    docker images | grep "<none>" | awk '{print $3}' | xargs docker rmi
    docker volume rm $(docker volume ls -qf dangling=true)
}

# Machine-specific configuration                                            {{{1
# ==============================================================================

source_if_exists "$HOME/.zshrc.machine.sh"
