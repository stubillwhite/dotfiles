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

# Helper aliases
alias tarf=tar\ -zcvf 
alias untarf=tar\ -zxvf 
alias assume-role=source\ ~/Dev/my-stuff/utils/assume-role.sh
alias eject=diskutil\ eject
alias env=env\ \|\ sort
alias tree=tree\ -A
alias ssh-purge-key=ssh-keygen\ -R
alias vim=nvim

# Include machine-specific configuration
source_if_exists "$HOME/.zshrc.machine.sh"

# Bash regex support
setopt BASH_REMATCH

# Clean up after annoying Emacs 25.1 crash on OSX
alias clean-emacs=rm\ -rf\ ~/.emacs-backup\ ~/.emacs-undo-tree

# SSH tunnelling helpers
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

# Executing scripts remotely
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

# function progress-bar() {
# 	local duration=${1}

#     gauge_start()  { printf "["; }
# 	already_done() { for ((done=0; done<$elapsed; done++)); do printf "="; done; }
# 	remaining()    { for ((remain=$elapsed; remain<$duration; remain++)); do printf " "; done; }
# 	percentage()   { printf " %s%%" $(( (($elapsed)*100)/($duration)*100/100 )); }
#     gauge_end()    { printf "]"; }
# 	clean_line()   { printf "\r"; }

# 	for (( elapsed=1; elapsed<=$duration; elapsed++ )); do
# 		clean_line; gauge_start; already_done; remaining; gauge_end; percentage
# 		sleep 0.1
# 	done
# }

function ds-anonymise-dataset() {
    if read -q '?Rename all files in directory to UUIDs. Are you sure? '
    then
        for i in * 
        do 
            local uuid=$(uuidgen | tr "[:upper:]" "[:lower:]")
            mv -v $i $uuid.${i##*.}
        done
    fi
}

function ds-download-files() {
    if [[ $# -ne 1 ]] ; then
        echo 'Download files from URLs in URLFILE'
        echo 'Usage: ds-download-files URLFILE'
        return -1
    fi

    wget --tries=1 --timeout=1 -i $1
}

# Git

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
            else
                # Not a Git repository
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

function prompt-help() {
  #zstyle ':prezto:module:git:info' verbose 'yes'
  #zstyle ':prezto:module:git:info:action' format '%F{7}:%f%%B%F{9}%s%f%%b'
  #zstyle ':prezto:module:git:info:added' format ' %%B%F{2}✚%f%%b'
  #zstyle ':prezto:module:git:info:ahead' format ' %%B%F{13}⬆%f%%b'
  #zstyle ':prezto:module:git:info:behind' format ' %%B%F{13}⬇%f%%b'
  #zstyle ':prezto:module:git:info:branch' format ' %%B%F{2}%b%f%%b'
  #zstyle ':prezto:module:git:info:commit' format ' %%B%F{3}%.7c%f%%b'
  #zstyle ':prezto:module:git:info:deleted' format ' %%B%F{1}✖%f%%b'
  #zstyle ':prezto:module:git:info:modified' format ' %%B%F{4}✱%f%%b'
  #zstyle ':prezto:module:git:info:position' format ' %%B%F{13}%p%f%%b'
  #zstyle ':prezto:module:git:info:renamed' format ' %%B%F{5}➜%f%%b'
  #zstyle ':prezto:module:git:info:stashed' format ' %%B%F{6}✭%f%%b'
  #zstyle ':prezto:module:git:info:unmerged' format ' %%B%F{3}═%f%%b'
  #zstyle ':prezto:module:git:info:untracked' format ' %%B%F{7}◼%f%%b'
  #zstyle ':prezto:module:git:info:keys' format \
    #'status' '$(coalesce "%b" "%p" "%c")%s%A%B%S%a%d%m%r%U%u'
    
  #The square signifies that there are untracked changes.
#The = signifies there are unmergerd changes.
#The -> signifies that something has been renamed.
#The 6-pointed blue star signifies that there is a modification.
#The red X signifies that something has been deleted.
#The green + signifies that something is added.
#The blue 5-pointed star signifies that something is stashed.
#The arrow pointing down means you are behind.
#The arrow pointing up means you are ahead.
#Not quite sure about the green V and the red arrow... they are listed as Vim and "overwrite."
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

