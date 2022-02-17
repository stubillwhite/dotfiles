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

# Tmuxinator
source_if_exists "$HOME/Dev/my-stuff/dotfiles/tmuxinator/tmuxinator.zsh"

# GNU parallel
source_if_exists "$(which env_parallel.zsh)"

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

# Useful things to pipe things into
alias fmt-xml='xmllint --format -'                                          # Prettify XML (cat foo.xml | fmt-xml)
alias fmt-json='jq "."'                                                     # Prettify JSON (cat foo.json | fmt-json)
alias tabulate-by-tab='gsed "s/\t\t/\t-\t/g" | column -t -s $''\t'' '       # Tabluate TSV (cat foo.tsv | tabulate-by-tab)
alias tabulate-by-comma='gsed "s/,,/,-,/g" | column -t -s '','' '           # Tabluate CSV (cat foo.csv | tabulate-by-comma)
alias as-stream='stdbuf -o0'                                                # Turn pipes to streams (tail -F foo.log | as-stream grep "bar")
alias strip-color="gsed -r 's/\x1b\[[0-9;]*m//g'"                           # Strip ANSI colour codes (some-cmd | strip-color)
alias strip-ansi="perl -pe 's/\x1b\[[0-9;]*[mG]//g'"                        # Strip all ANSI control codes (some-cmd | strip-ansi)
alias sum-of="paste -sd+ - | bc"                                            # Sum numbers from stdin (some-cmd | sum-of)

alias csv-to-json="python3 -c 'import csv, json, sys; print(json.dumps([dict(r) for r in csv.DictReader(sys.stdin)]))'"

alias ssh-rm-connections='rm /tmp/ssh-mux_*'
alias py-env-activate='source bin/activate'
alias py-env-deactivate='deactivate'

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

# Specific tools                                                            {{{1
# ==============================================================================

# KeePassXC                         {{{2
# ======================================

alias keepassxc-cli='/Applications/KeePassXC.app/Contents/MacOS/keepassxc-cli'

# Ripgrep                           {{{2
# ======================================

export RIPGREP_CONFIG_PATH=~/.ripgreprc

# FZF                               {{{2
# ======================================

export FZF_DEFAULT_COMMAND="fd --exclude={.git,.idea,.vscode,target,node_modules,build} --type f"

# Shellcheck                        {{{2
# ======================================

export SHELLCHECK_OPTS=""
SHELLCHECK_OPTS+="-e SC1091 "    # Allow sourcing files from paths that do not exist yet
SHELLCHECK_OPTS+="-e SC2039 "    # Allow dash in function names
SHELLCHECK_OPTS+="-e SC2112 "    # Allow 'function' keyword
SHELLCHECK_OPTS+="-e SC2155 "    # Allow declare and assignment in the same statement

# SBT                               {{{2
# ======================================

export SBT_OPTS=-Xmx2G
alias sbt-no-test='sbt "set test in assembly := {}"'
alias sbt-test='sbt test it:test'

# Switch between standard and cleanroom builds
function use-artifactory () {
    if [[ $# -ne 1 ]] ; then
        echo 'Usage: use-artifactory (cleanroom|standard)'
        return 1
    fi

    echo "Switching to ${1} repository"

    rm ~/.sbt/repositories 
    rm ~/.ivy2

    ln -s "$HOME/.sbt/repositories-${1}" ~/.sbt/repositories 
    ln -s "$HOME/.ivy2-${1}"             ~/.ivy2
}
compdef "_arguments \
    '1:environment arg:(cleanroom standard)'" \
    use-artifactory

# jq                                {{{2
# ======================================

# Display the paths to the values in the JSON
# cat foo.json | jq-paths
function jq-paths() {
    # Taken from https://github.com/stedolan/jq/issues/243 
    jq '[path(..)|map(if type=="number" then "[]" else tostring end)|join(".")|split(".[]")|join("[]")]|unique|map("."+.)|.[]'
}

# Python                            {{{2
# ======================================

# Initialise the Python virtual environment
function py-env-init() {
    python3 -m venv .
    touch requirements.txt
    py-env-activate
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

# For each directory within the current directory, if the directory is a Git
# repository then execute the supplied function in parallel
function git-for-each-repo-parallel() {
    local dirs=$(find . -type d -depth 1)

    echo "$dirs" \
        | env_parallel --env "$1" -j20 \
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
        if [[ "$gitRepoStatus[branch]" =~ (main) ]]; then
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

        echo "${branch},${sync},${dirty},${repo}"
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
        local cmd="git --no-pager log-recent --author='Jenkins' --invert-grep"
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

function git-repos-author-line-count() {
    author-line-count() {
        git ls-files \
            | xargs -n1 git blame -w -M -C -C --line-porcelain \
            | sed -n 's/^author //p' 
    }

    git-for-each-repo author-line-count | sort -f | uniq -ic | sort -nr
}

function git-repos-contributor-stats() {
    contributor-stats() {
        git --no-pager log --format="%aN" --no-merges
    }

    git-for-each-repo contributor-stats | sort | uniq -c | sort -r
}

function git-repos-authors() {
    authors() {
        git --no-pager log | grep "Author:" | sort | uniq
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
        git remote -v | grep '(fetch)' | awk '{ print $2 }'
    }

    git-for-each-repo remotes
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
        local hostname=$(ssh -G "${hostAlias}" | awk '$1 == "hostname" { print $2 }')

        echo "$URL" \
            | sed -E "s|git@(.*):(.*).git|https://${hostname}/\2/${pathInRepo}|" \
            | xargs "${OPEN_CMD}"

    elif [[ $URL =~ ^https://bitbucket.org ]]; then
        echo "$URL" \
            | sed -E "s|(.*).git|\1/src/${branch}/${pathInRepo}|" \
            | xargs "${OPEN_CMD}"

    elif [[ $URL =~ ^https://github.com ]]; then
        [[ -n "${pathInRepo}" ]] && pathInRepo="tree/${branch}/${pathInRepo}"
        echo "$URL" \
            | sed -E "s|(.*).git|\1/${pathInRepo}|" \
            | xargs "${OPEN_CMD}"

    else
        echo "Failed to open due to unrecognised URL '$URL'"
    fi

    [[ -n "${filename}" ]] && popd > /dev/null 2>&1
}

# Archive the Git branch by tagging then deleting it
function git-archive-branch() {
    if [[ $# -ne 1 ]] ; then
        echo 'Archive Git branch by tagging then deleting it'
        echo 'Usage: git-archive-branch BRANCH'
        return 1
    fi

    # git tag archive/$1 $1
    git branch -D $1
}
compdef '_alternative \
  "arguments:custom arg:($(git branch --no-merged main))" \
  ' \
  git-archive-branch

#git branch --no-merged main

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
        exit -1
    fi

    local user=$1
    local base_url="https://api.github.com:443/users/${user}/repos"

    # Get user email and token, for which we unfortunately need a repo
    local tmpDir=$(mktemp -d --tmpdir=.)
    cd ${tmpDir}
    git init > /dev/null

    local token=$(git config --get user.token)
    local email=$(git config --get user.email)

    cd ..
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
        | jq -r '.[] | [ .updated_at, .name ] | @csv' \
        | tabulate-by-comma \
        | sort -r \
        | gsed 's/"//g'
}

# General functions                                                         {{{1
# ==============================================================================

# File helpers                      {{{2
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

# Run gunzip on all files under the current directory
function gunzip-logs() {
    while read -r line; do
        echo "$line"
        gunzip "$line"
    done < <(find . -name "*.gz")
}

# Miscellaneous utilities           {{{2
# ======================================

# Prompt for confirmation
# confirm "Delete [y/n]?" && rm -rf *
function confirm() {
    read response\?"${1:-Are you sure?} [y/N] "
    case "$response" in
        [Yy][Ee][Ss]|[Yy]) 
            true
            ;;
        *)
            false
            ;;
    esac
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
compdef '_alternative "arguments:custom arg:(red green yellow blue magenta cyan)"' highlight

# Convert milliseconds since the epoch to the current date time
# echo 1633698951550 | epoch-to-date
function epoch-to-date() {
    while IFS= read -r msSinceEpoch; do
        awk -v t="${msSinceEpoch}" 'BEGIN { print strftime("%Y-%m-%d %H:%M:%S", t/1000); }'
    done
}

# Calculate the result of an expression
# calc 2 + 2
function calc () { 
    echo "scale=2;$*" | bc | sed 's/\.0*$//'
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

function aws-export-current-credentials() {
    echo "export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} && export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}"
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

# Docker

function docker-rm-instances() {
    docker ps -a -q | xargs docker stop
    docker ps -a -q | xargs docker rm
}

function docker-rm-images() {
    if confirm; then
        docker-rm-instances
        docker images -q | xargs docker rmi
        docker images | grep "<none>" | awk '{print $3}' | xargs docker rmi
    fi
}

# k9s

function k9s-logs() {
    echo "$(k9s info | no-color | grep Logs | gsed -r 's/^Logs:\s+//g' | xargs dirname)/k9s-screens-white1"
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

source_if_exists "$HOME/.zshrc.no-commit"
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
