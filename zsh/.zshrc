# vim:fdm=marker

# Included scripts                                                          {{{1
# ==============================================================================

# No flow control, so C-s is free for C-r/C-s back/forward incremental search
stty -ixon

# Include Prezto, but remove unhelpful configuration

zstyle ':prezto:module:git:alias' skip 'yes' # No Git aliases

source_if_exists "$HOME/.zprezto/init.zsh"

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
    alias gif-recorder='/Applications/LICEcap.app/Contents/MacOS/licecap'
    alias assume-role='source ~/Dev/my-stuff/utils/assume-role.sh'
}

if_linux && {
    alias gsed='sed'
    alias open='xdg-open'
}

# More helpful aliases for programs that change frequently
alias gg='rg'                                                               # Grep

# Better command defaults
alias eject='diskutil eject'                                                # Eject disk
alias env='env | sort'                                                      # env should be sorted
alias tree='tree -A'                                                        # tree should be ascii
alias watch='watch -x zsh -ic'                                              # watch should use interactive Zsh shell for functions
alias entr='entr -c'                                                        # entr should be colourised
alias gh='NO_COLOR=1 gh'                                                    # gh should not be colourised
alias vi='nvim'                                                             # Use nvim instead of vi
alias vim='nvim'                                                            # Use nvim instead of vim
alias sed='gsed'                                                            # Use gsed instead of sed

# Other useful stuff
alias reload-zsh-config="exec zsh"                                          # Reload Zsh config
alias display-colours='msgcat --color=test'                                 # Display terminal colors
alias create-react-app='npx create-react-app'                               # Shortcut to create a new React app
alias ssh-add-keys='ssh-add ~/.ssh/keys/id_rsa_personal'                    # Add standard keys to SSH agent
alias ssh-purge-key='ssh-keygen -R'                                         # Remove key from SSH files (ssh-purge-key 10.188.188.192)
alias list-ports='netstat -anv'                                             # List active ports
alias aws-local='aws --endpoint-url=http://localhost:4566'                  # AWS CLI commands pointing at localstack

alias i2cssh='i2cssh -p stuw --iterm2'
alias shred='shred -vuz --iterations=10'
alias git-clean='git clean -X -f -d'
alias git-scrub='git clean -x -f -d'
alias docker-entrypoint='docker inspect --format="{{.Config.Cmd}}"'

# General functions                                                         {{{1
# ==============================================================================

# Grep zipped logs
function zgrep-logs() {
    declare pattern=$1
    zgrep -iR "${pattern}" . --context 10
}

# Run gunzip on all files under the current directory
function gunzip-logs() {
    while read -r line; do
        echo "$line"
        gunzip "$line"
    done < <(find . -name "*.gz")
}

# Switch between SSH configs
function ssh-config() {
    mv ~/.ssh/config ~/.ssh/config.bak
    ln -s "$HOME/.ssh/config-${1}" ~/.ssh/config
}
compdef '_alternative "arguments:custom arg:(recs newsflo)"' ssh-config

# AWS                               {{{2
# ======================================

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

# List ECR images
function aws-list-ecr-images() {
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

# AWS                               {{{2
# ======================================

function aws-datapipeline-definitions() {
    while IFS=, read -rA x 
    do
        pipelineId=${x[@]:0:1}
        pipelineName=$(echo "${x[@]:1:1}" | tr '[A-Z]' '[a-z]' | tr ' ' '-')
        echo $pipelineName
        aws datapipeline get-pipeline-definition --pipeline-id $pipelineId \
            | jq '.' \
            > "pipeline-definition-${pipelineName}"
    done < <(aws datapipeline list-pipelines | jq --raw-output '.pipelineIdList[] | [.id, .name] | @csv' | sed 's/"//g') \
}

function aws-datapipeline-requirements() {
    while IFS=, read -rA x 
    do
        pipelineId=${x[@]:0:1}
        pipelineName=${x[@]:1:1}
        aws datapipeline get-pipeline-definition --pipeline-id $pipelineId \
            | jq --raw-output ".values | [\"$pipelineName\", .my_master_instance_type, \"1\", .my_core_instance_type, .my_core_instance_count, .my_env_subnet_private]| @csv"
    done < <(aws datapipeline list-pipelines | jq --raw-output '.pipelineIdList[] | [.id, .name] | @csv' | sed 's/"//g') \
        | sed 's/"//g' \
        | column -t -s '','' 
}

function aws-subnets() {
    # while IFS=, read -rA x 
    # do
    #     addressesInUse=$(aws ec2 describe-network-interfaces --filters Name=subnet-id,Values=${x} \
    #         | jq --raw-output '.NetworkInterfaces[].PrivateIpAddresses' \
    #         | wc -l)
    #     printf "%s,%s\n" ${x} ${addressesInUse}
    # done < <(aws ec2 describe-subnets | jq --raw-output ".Subnets[].SubnetId") \
    #     | sed 's/"//g' \
    #     | column -t -s '','' 

    aws ec2 describe-subnets \
        | jq -r ".Subnets[] | [ .SubnetId, .AvailableIpAddressCount ] | @csv" \
        | sed 's/"//g' \
        | column -t -s '',''
}

function aws-datapipeline-amis() {
    while IFS=, read -rA x 
    do
        pipelineId=${x[@]:0:1}
        pipelineName=${x[@]:1:1}
        aws datapipeline get-pipeline-definition --pipeline-id $pipelineId \
            | jq --raw-output "                                            \
                    .objects[]                                             \
                    | select(has(\"imageId\"))                             \
                    | [\"$pipelineName\", .[\"imageId\"]]                  \
                    | @csv"
    done < <(aws datapipeline list-pipelines | jq --raw-output '.pipelineIdList[] | [.id, .name] | @csv' | sed 's/"//g') \
        | sed 's/"//g' \
        | column -t -s '','' 
}

function aws-datapipeline-amis() {
    while IFS=, read -rA x 
    do
        pipelineId=${x[@]:0:1}
        pipelineName=${x[@]:1:1}
        aws datapipeline get-pipeline-definition --pipeline-id $pipelineId      \
            | jq --raw-output "                                                 \
                    [\"$pipelineName\",                                         \
                     (.objects[] | select(has(\"imageId\")) | .[\"imageId\"]),  \
                     (.values[\"my_ec2_machine_ami_id\"])]                      \
                    | @csv"
    done < <(aws datapipeline list-pipelines | jq --raw-output '.pipelineIdList[] | [.id, .name] | @csv' | sed 's/"//g') \
        | sed 's/"//g' \
        | column -t -s '','' 
}

function aws-lambda-statuses() {
    aws lambda list-event-source-mappings \
        | jq -r ".EventSourceMappings[] | [.FunctionArn, .EventSourceArn, .State, .UUID] | @tsv" \
        | gsed "s/\t\t/\t-\t/g" \
        | column -t -s $'\t' \
        | sort \
        | highlight red '.*Disabled.*' \
        | highlight yellow '.*\(Enabling\|Disabling\|Updating\).*'
}

function aws-service-quotas() {
    aws service-quotas list-service-quotas --service-code ec2 | jq --raw-output '(.Quotas[] | ([.QuotaName, .Value])) | @csv' | column -t -s "," | sed 's/\"//g'
}

function aws-datapipeline-record-loader-versions() {
    while IFS=, read -rA x 
    do
        pipelineId=${x[@]:0:1}
        pipelineName=${x[@]:1:1}
        aws datapipeline get-pipeline-definition --pipeline-id $pipelineId      \
            | jq --raw-output "                                                 \
                    [\"$pipelineName\",                                         \
                     (.values[\"my_record_loader_version\"])]                   \
                    | @csv"
    done < <(aws datapipeline list-pipelines | jq --raw-output '.pipelineIdList[] | [.id, .name] | @csv' | sed 's/"//g') \
        | sed 's/"//g' \
        | column -t -s '','' 
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

# Open the specified S3 bucket
function aws-s3-open() {
    local s3Path=$1
    echo "Opening '$s3Path'"
    echo "$s3Path" \
        | sed -e 's/^.*s3:\/\/\(.*\)/\1/' \
        | sed -e 's/^/https:\/\/s3.console.aws.amazon.com\/s3\/buckets\//' \
        | sed -e 's/$/?region=us-east-1/' \
        | xargs "$OPEN_CMD"
}

function aws-get-secrets() {
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

function response-times() {
    if [[ $# -ne 1 ]] ; then
        echo 'Find reponse times for URL'
        echo 'Usage: response-times URL'
        return 1
    fi

    local url=$1

    echo "code,time_total,time_connect,time_appconnect,time_pretransfer,time_starttransfer"
    for i in $(seq 1 10); do
        curl \
            --write-out "%{http_code},%{time_total},%{time_connect},%{time_appconnect},%{time_pretransfer},%{time_starttransfer}\n" \
            --silent \
            --output /dev/null \
            "${url}"
    done
}

function g-rebase-branch() {
    local trunk='main'

    git branch --show-current \
        | xargs git merge-base ${trunk} \
        | xargs git rebase -i
}

function g-one-commit() {
    local trunk=main
    local lastCommitMessage=$(git show -s --format=%s)

    git branch --show-current \
        | xargs git merge-base ${trunk} \
        | xargs git reset --soft
    git add -A
    git commit -m "${lastCommitMessage}"
    git commit --amend
}
