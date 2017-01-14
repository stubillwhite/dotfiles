# Include common configuration
source $HOME/.common.sh

# Include completion functions
fpath=(~/.zsh-completion $fpath)
autoload -U compinit
compinit

# Include Prezto, but remove unhelpful configuration
source_if_exists "$HOME/.zprezto/init.zsh"
unalias cp                      # Standard behaviour
unalias rm                      # Standard behaviour
unalias mv                      # Standard behaviour
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

# Include machine-specific configuration
source_if_exists "$HOME/.zshrc.machine.sh"

# Bash regex support
setopt BASH_REMATCH

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

alias tunnel-staging-solr='tunnel-open 8983 solr-staging.els.vpc.local 8983 admin@bastion-elb-staging-50509670.us-east-1.elb.amazonaws.com'
alias tunnel-staging-zk='tunnel-open 2181 10.93.32.243 2181 admin@bastion-elb-staging-50509670.us-east-1.elb.amazonaws.com'
alias tunnel-staging-aurora='tunnel-open 3307 aurora-newsflo-staging.cluster-cb2nmxldkcq1.us-east-1.rds.amazonaws.com 3306 admin@bastion-elb-staging-50509670.us-east-1.elb.amazonaws.com'
alias tunnel-live-aurora='tunnel-open 3306 aurora-newsflo-live.cluster-ro-cyva1uzg7p7h.us-east-1.rds.amazonaws.com 3306 s.white@bastion.live.newsflo'

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
