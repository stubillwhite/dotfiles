# Ruby stuff
export RBENV_ROOT=/usr/local/var/rbenv
 
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
 
export PATH=$RBENV_ROOT/shims:$PATH
export SBT_CREDENTIALS=~/.sbt/0.13/.credentials
export M2_HOME=/usr/local/Cellar/maven/3.3.9/libexec

source ~/.bashrc
