function source_if_exists { 
    if [[ -s $1 ]]; then
        source $1
    #else
        #echo "Skipping sourcing $1 as it does not exist"
    fi
}

# Unlimited history

export HISTFILESIZE=
export HISTSIZE=

# Use NVim 

export EDITOR=nvim
export VISUAL=nvim

# Perl

PATH="/Users/white1/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/Users/white1/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/Users/white1/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/Users/white1/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/Users/white1/perl5"; export PERL_MM_OPT;

# Other tools

export PATH=$PATH:/Applications/Beyond\ Compare.app/Contents/MacOS
export PATH=$PATH:~/Dev/tools/spark-2.0.0-bin-hadoop2.7/bin
export PATH=$PATH:~/Dev/tools
export PATH=$PATH:~/Dev/my-stuff/utils
export PATH=$PATH:~/Dev/my-stuff/utils
export PATH=$PATH:/usr/bin

# SSH

SSH_ENV_FILE="$HOME/.ssh/environment"

function ssh_start_agent {
    echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV_FILE}"
    chmod 600 "${SSH_ENV_FILE}"
    . "${SSH_ENV_FILE}" > /dev/null
    /usr/bin/ssh-add;
}

if [ -f "${SSH_ENV_FILE}" ]; then
    . "${SSH_ENV_FILE}" > /dev/null
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
    ssh_start_agent;
}
else
    ssh_start_agent;
fi

function ssh_add_keys {
    for FILE in $HOME/.ssh/*.pem; do
        ssh-add $FILE
    done
    ssh-add $HOME/.ssh/stuart.white
}

function docker_machine_start {
    ~/docker_setup_mac.bash
    docker-machine start
    eval $(docker-machine env default)
    echo "Initialised environment"
}

function docker-ips() {
    docker ps | while read line; do
    if `echo $line | grep -q 'CONTAINER ID'`; then
        echo -e "IP ADDRESS\t$line"
    else
        CID=$(echo $line | awk '{print $1}');
        IP=$(docker inspect -f "{{ .NetworkSettings.IPAddress }}" $CID);
        printf "${IP}\t${line}\n"
    fi
done;
}

#docker ps | tail -n +2 | cut -d " " -f 1 | docker inspect | jq '.[0].NetworkSettings.IPAddress'

function awssh() {
    servers=$(aws ec2 describe-instances --region eu-west-1 --profile newsflo --output json | jq '.Reservations[].Instances[] | select(.Tags != null) | select(.Tags[].Value | select(. != null) | contains("'$1'")) | .PrivateIpAddress'|  sort | uniq | head -n 10)
    num=$(echo "$servers" | wc -l)
    servers=$(echo "$servers" | tr -d '"')
    if [ $num -eq 1 ]; then
        ssh "$servers"
    else
        echo "$servers" | xargs csshX --login stuart.white
    fi
}
