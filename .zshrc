# vim:fdm=marker

# Profiling for startup                                                     {{{1
# ==============================================================================
# Enable profiling (display report with `zprof`)

zmodload zsh/zprof

# Included scripts                                                          {{{1
# ==============================================================================

# Include common configuration
source $HOME/.commonrc

# No flow control, so C-s is free for C-r/C-s back/forward incremental search
stty -ixon

# Include completion functions
fpath=(~/.zsh-completion $fpath)
autoload -U compinit
compinit

# Pyenv
## export PYENV_ROOT="$HOME/Dev/tools/pyenv"
## export PATH="$PYENV_ROOT/bin:$PATH"
## if command -v pyenv 1>/dev/null 2>&1; then
##     eval "$(pyenv init -)"
## fi

# Include Prezto, but remove unhelpful configuration
source_if_exists "$HOME/.zprezto/init.zsh"
unalias cp &> /dev/null         # Standard behaviour
unalias rm &> /dev/null         # Standard behaviour
unalias mv &> /dev/null         # Standard behaviour
unalias grep &> /dev/null       # Standard behaviour
setopt clobber                  # Happily clobber files
setopt interactivecomments      # Allow comments in interactive shells
unsetopt AUTO_CD                # Don't change directory automatically
unsetopt AUTO_PUSHD             # Don't push directory automatically

# AWS tools
source_if_exists "/usr/local/bin/aws_zsh_completer.sh"

# General options                                                           {{{1
# ==============================================================================

setopt BASH_REMATCH             # Bash regex support
setopt menu_complete            # Tab autocompletes first option even if ambiguous

# Aliases                                                                   {{{1
# ==============================================================================

if_darwin && {
    alias files-show='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
    alias files-hide='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'
    alias cookiecutter='~/Library/Python/3.7/bin/cookiecutter'
    alias gif-recorder='/Applications/LICEcap.app/Contents/MacOS/licecap'
    alias assume-role='source ~/Dev/my-stuff/utils/assume-role.sh'
}

if_linux && {
    alias gsed='sed'
    alias open='xdg-open'
}

alias eject='diskutil eject'
alias env='env | sort'
alias tree='tree -A'
alias watch='watch -c'
alias ssh-purge-key='ssh-keygen -R'
alias ssh-rm-connections='rm /tmp/ssh-mux_*'
alias strip-ansi="perl -pe 's/\x1b\[[0-9;]*[mG]//g'"
alias python-env-init='python3 -m venv .'
alias python-env-activate='source bin/activate'
alias python-env-deactivate='deactivate'
alias gource='gource -f --auto-skip-seconds 1 --seconds-per-day 0.05'
alias fmt-xml='xmllint --format -'
alias fmt-json='jq "."'
alias entr='entr -c'
alias list-ports='netstat -anv'
alias tabulate-by-tab='column -t -s $''\t'' '
alias tabulate-by-comma='column -t -s '','' '
alias i2cssh='i2cssh -p stuw --iterm2'
alias sum='paste -s -d+ - | bc'
alias shred='shred -vuz --iterations=10'

alias vi='nvim'
alias vim='nvim'
alias emacs-new='/usr/bin/env HOME=/Users/white1/Dev/my-stuff/.emacs.d.new emacs'
alias emacs-spacemacs='/usr/bin/env HOME=/Users/white1/Dev/my-stuff/.emacs.d.spacemacs emacs'

# Specific tools                                                            {{{1
# ==============================================================================

# Shellcheck                        {{{2
# ======================================

export SHELLCHECK_OPTS=""
SHELLCHECK_OPTS+="-e SC1091 "    # Allow sourcing files from paths that do not exist yet
SHELLCHECK_OPTS+="-e SC2039 "    # Allow dash in function names
SHELLCHECK_OPTS+="-e SC2112 "    # Allow 'function' keyword

# SBT                               {{{2
# ======================================

export SBT_OPTS=-Xmx2G
alias sbt-no-test='sbt "set test in assembly := {}"'

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
    tar -zcvf "${fnam%/}".tar.gz "$1"
}

# Untar a file
function untarf() {
    declare fnam=$1
    tar -zxvf "$1"
}

# Grep zipped logs
function zgrep-logs() {
    declare pattern=$1
    zgrep -iR "${pattern}" . --context 10
}

# Colorize output
# ls | colorize green *.log
function colorize() {
    if [[ $# -ne 2 ]] ; then
        echo 'Usage: colorize COLOR PATTERN'
        return 1
    fi

    color=$1
    pattern=$2

    awk -v color=$color -v pattern=$pattern -f ~/Dev/my-stuff/shell-utils/colorize
}
compdef '_alternative "arguments:custom arg:(red green yellow blue magenta cyan)"' colorize

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
    ssh -AL ${localPort}:${host}:${hostPort} ${server} -f -o ServerAliveInterval=30 -N -M -S ${connectionFile} || { echo "Failed to open tunnel"; return -1; }
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

function sshx-tagged-aws-machines() {
    if [[ $# -ne 3 ]] ; then
        echo 'Usage: sshx-tagged-aws-machines PROFILE REGION TAG'
        return 1
    fi

    declare profile=$1 region=$2 tag=$3

    echo 'Finding machines'
    machines=($(aws --profile $profile ec2 describe-instances --region $region | jq --raw-output '.Reservations[].Instances[]? | select(.State.Name=="running") | select(.Tags[] | select((.Key=="Name") and (.Value=="'$tag'"))) | .NetworkInterfaces[].PrivateIpAddresses[].PrivateIpAddress'))

    echo "Opening SSH to $machines[*]"
    i2cssh $machines[*]
}

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

function aws-all-instance-ips() {
    if [[ $# -ne 2 ]] ; then
        echo 'Usage: aws-all-instance-ips PROFILE REGION'
        return 1
    fi

    local profile=$1
    local region=$2

    aws --profile $profile ec2 describe-instances --region $region | jq --raw-output '["Name", "IP address", "Instance ID", "Instance type", "AMI ID", "Launch time", "Monitoring"], (.Reservations[].Instances[]? | select(.State.Name=="running") | [ (.Tags[]? | (select(.Key=="Name")).Value) // "-", .NetworkInterfaces[].PrivateIpAddresses[].PrivateIpAddress, .InstanceId, .InstanceType, .ImageId, .LaunchTime, .Monitoring.State]) | @csv' | sort | column -t -s "," | sed 's/\"//g'
}
compdef _aws-profile-region aws-all-instance-ips

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

# Display AWS instance limits
function aws-ec2-instance-limits() {
    aws service-quotas list-service-quotas --service-code ec2 | jq --raw-output '(.Quotas[] | ([.QuotaName, .Value])) | @csv' | column -t -s "," | sed 's/\"//g'
}

# Copy my base machine config to a remote host
function scp-skeleton-config() {
    if [[ $# -ne 1 ]] ; then
        echo 'Usage: scp-skeleton-config HOST'
        exit -1
    fi

    pushd ~/Dev/my-stuff/dotfiles/skeleton-config || exit 1
    echo "Uploading config to $1"
    for file in $(find . \! -name .); do
        scp $file $1:$file
    done
    popd || exit 1
}
compdef _ssh scp-skeleton-config=ssh

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

# Java certificate management       {{{2
# ======================================

if_darwin && {
    export JAVA_CERT_LOCATION=$(/usr/libexec/java_home)/jre/lib/security/cacerts
}

if_linux && {
    export JAVA_CERT_LOCATION=$JAVA_HOME/jre/lib/security/cacerts
}

function cert-download() {
    local usage='Download a certificate\nUsage:\n  cert-download HOST'
    validate_usage "${usage}" 1 "$@" || return 1

    declare host=$1
    echo "Downloading certificate to $host.crt"
    openssl x509 -in <(openssl s_client -connect "$host":443 -prexit 2>/dev/null) -out "$host".crt
}

function cert-import() {
    local usage='Import a certificate\nUsage:\n  cert-import FNAM ALIAS'
    validate_usage "${usage}" 2 "$@" || return 1

    declare fnam=$1 alias=$2
    echo "Importing certificate $fnam as $alias"
    sudo keytool -importcert -file "$fnam" -alias "$alias" -keystore $JAVA_CERT_LOCATION -storepass changeit
}

function cert-delete() {
    local usage='Delete a certificate\nUsage:\n  cert-delete ALIAS'
    validate_usage "${usage}" 1 "$@" || return 1

    declare alias=$1
    echo "Deleting certificate $alias"
    sudo keytool -delete -alias "$alias" -keystore $JAVA_CERT_LOCATION -storepass changeit
}

function cert-list() {
    sudo keytool -list -keystore $JAVA_CERT_LOCATION -storepass changeit
}

function cert-store-path() {
    echo "Keystore is $JAVA_CERT_LOCATION"
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

    if_darwin && {
        osascript -e "display notification \"$msg\" with title \"tell-me\""
    }

    if_linux && {
        notify-send -t 2000 "tell-me" "$msg"
    }
}

# jq                                {{{2
# ======================================

function jq-paths() {
    # Taken from https://github.com/stedolan/jq/issues/243 
    jq '[path(..)|map(if type=="number" then "[]" else tostring end)|join(".")|split(".[]")|join("[]")]|unique|map("."+.)|.[]'
}

# Git                               {{{2
# ======================================

# For each directory within the current directory, if the directory is a Git
# repository then execute the supplied function 
function git-for-each-repo() {
    setopt local_options glob_dots
    for fnam in *; do
        if [[ -d $fnam ]]; then
            pushd "$fnam" > /dev/null || return 1
            if git rev-parse --git-dir > /dev/null 2>&1; then
                "$@"
            fi
            popd > /dev/null || return 1
        fi
    done
}

# For each directory within the current directory, pull the repo
function git-repos-pull() (
    pull-repo() {
        echo "Pulling $(basename $PWD)"
        git pull -r --autostash
        echo
    }

    git-for-each-repo pull-repo 
)

# For each directory within the current directory, fetch the repo
function git-repos-fetch() (
    local args=$*

    fetch-repo() {
        echo "Fetching $(basename $PWD)"
        git fetch ${args}
        echo
    }

    git-for-each-repo fetch-repo 
)

# For each directory within the current directory, display the status line for the repo
# Requires Prezto prompt to work
function git-repos-status-detailed() (
    display-status() {
        git-info
        print -P "$(basename $PWD) ${git_info[status]}"
    }

    prompt-help
    git-for-each-repo display-status | column -t -s ' '
)

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

    branch=$(git rev-parse --abbrev-ref HEAD)

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

function git-repos-status() (
    display-status() {
        git-parse-repo-status
        repo=$(basename $PWD) 

        local branch="${COLOR_GREEN}master${COLOR_NONE}"
        if [[ ! $gitRepoStatus[branch] == "master" ]]; then
            branch="${COLOR_RED}$gitRepoStatus[branch]${COLOR_NONE}"
        fi

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

        echo "${branch},${sync},${dirty},${repo}"
    }

    git-for-each-repo display-status | column -t -s ','
)

# For each directory within the current directory, display whether the
# directory contains unmerged branches locally
function git-repos-unmerged-branches() (
    display-unmerged-branches() {
        unmergedBranches=$(git branch --no-merged master) 
        if [[ $unmergedBranches = *[![:space:]]* ]]; then
            echo "$fnam"
            git branch --no-merged master
            echo
        fi
    }

    git-for-each-repo display-unmerged-branches
)

# For each directory within the current directory, display whether the
# directory contains unmerged branches locally and remote
function git-repos-unmerged-branches-all() {
    display-unmerged-branches-all() {
        unmergedBranches=$(git branch --no-merged master) 
        if [[ $unmergedBranches = *[![:space:]]* ]]; then
            echo "$fnam"
            git branch --all --no-merged master
            echo
        fi
    }

    git-for-each-repo display-unmerged-branches-all
}

# For each directory within the current directory, generate a hacky lines of
# code count 
function git-repos-hacky-line-count() {
    display-hacky-line-count() {
        git ls-files > ../file-list.txt
        lineCount=$(cat < ../file-list.txt | grep -e "\(scala\|py\|java\|sql\|elm\|tf\|yaml\|pp\|yml\)" | xargs cat | wc -l)
        echo "$fnam $lineCount"
        totalCount=$((totalCount + lineCount))
    }

    git-for-each-repo display-hacky-line-count | column -t -s ' ' | sort -b -k 2.1 -n --reverse
}

# Display remote branches which have been merged
function git-merged-branches() {
    git branch -r | xargs -t -n 1 git branch -r --contains
}

# Open the git repo in the browser
function git-open() {
    URL=$(git config remote.origin.url)
    echo "Opening '$URL'"
    if [[ $URL =~ "git@" ]]; then
        echo "$URL" | sed -e 's/:/\//' | sed -e 's/git@/http:\/\//' | xargs $OPEN_CMD
    elif [[ $URL =~ ^https:(.+)@bitbucket.org/(.+) ]]; then
        echo "$URL" | sed -e 's/.git$//' | xargs $OPEN_CMD 
    elif [[ $URL =~ "^https:" ]]; then
        echo "$URL" | xargs $OPEN_CMD
    else
        echo "Failed to open due to unrecognised URL '$URL'"
    fi
}

# Archive the Git branch by tagging then deleting it
function git-archive-branch() {
    if [[ $# -ne 1 ]] ; then
        echo 'Archive Git branch by tagging then deleting it'
        echo 'Usage: git-archive-branch BRANCH'
        return 1
    fi

    git tag archive/$1 $1
    git branch -D $1
}

# Configure personal email
function git-config-personal-email() {
    git config user.email "stubillwhite@gmail.com"
}

# Configure work email
function git-config-work-email() {
    git config user.email "s.white.1@elsevier.com"
}

# Git stats for the current repo
function git-contributor-stats() {
    echo "Commit count"
    git shortlog -sn --no-merges

    echo
    echo "Line count"
    git ls-tree -r --name-only HEAD | grep -ve "\(\.json\|\.sql\)" | xargs -n1 git blame --line-porcelain HEAD | grep "^author " | sort | uniq -c | sort -nr
    #git log --no-merges --pretty='@%an' --shortstat | tr '\n' ' ' | tr '@' '\n'
}

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

function aws-datapipeline-requirements() {
    while IFS=, read -rA x 
    do
        pipelineId=${x[@]:0:1}
        pipelineName=${x[@]:1:1}
        aws datapipeline get-pipeline-definition --pipeline-id $pipelineId \
            | jq --raw-output ".values | [\"$pipelineName\", .my_master_instance_type, \"1\", .my_core_instance_type, .my_core_instance_count]| @csv"
    done < <(aws datapipeline list-pipelines | jq --raw-output '.pipelineIdList[] | [.id, .name] | @csv' | sed 's/"//g') \
        | sed 's/"//g' \
        | column -t -s '','' 
}

function aws-service-quotas() {
    aws service-quotas list-service-quotas --service-code ec2 | jq --raw-output '(.Quotas[] | ([.QuotaName, .Value])) | @csv' | column -t -s "," | sed 's/\"//g'
}

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

function docker-rm-instances() {
    docker ps -a -q | xargs docker stop
    docker ps -a -q | xargs docker rm
}

function docker-rm-images() {
    docker-rm-instances
    docker images -q | xargs docker rmi
    docker images | grep "<none>" | awk '{print $3}' | xargs docker rmi
}

function docker-rm-dangling-images() {
    docker ps -a -q | xargs docker stop
    docker ps -a -q | xargs docker rm -v
    docker images -q | xargs docker rmi
    docker images | grep "<none>" | awk '{print $3}' | xargs docker rmi
    docker volume rm $(docker volume ls -qf dangling=true)
}

# Machine-specific configuration                                            {{{1
# ==============================================================================

if_linux && {
    source_if_exists "$HOME/.zshrc.linux"

    # Link trash at ~/trash
    if [ ! -d "$HOME/trash" ]; then ln -s "$HOME/.local/share/Trash" "$HOME/trash"; fi
}

if_darwin && {
    source_if_exists "$HOME/.zshrc.darwin"

    # Link trash at ~/trash
    if [ ! -d "$HOME/trash" ]; then ln -s "$HOME/.Trash" "$HOME/trash"; fi
}

source_if_exists "$HOME/.zshrc.$(uname -n)"
