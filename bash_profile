#
# ~/.bash_profile
#

# check for an interactive session
[ -z "$PS1" ] && return

# PATH -----------------------------------------------------------------------

export PATH="$HOME/.yarn/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

# environment variables ------------------------------------------------------
export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:/usr/local/opt/findutils/share/man:$MANPATH"
export LANG="en_US.UTF-8"
export EDITOR="/usr/local/bin/nvim"
export SUDO_EDITOR="$EDITOR"
export GOPATH=$HOME/work
export PATH="$GOPATH/bin:$HOME/bin:$PATH"
export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
export LESS='-R'
export LESSOPEN='|~/.lessfilter %s'

# imports --------------------------------------------------------------------

source ~/.bash/venv-completion.bash
source ~/.bash/git-completion.bash
export GITAWAREPROMPT=~/.bash/git-aware-prompt
source "${GITAWAREPROMPT}/main.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

eval "$(stack --bash-completion-script stack)"
eval "$(pyenv init -)"

. ~/erlang/19.0/activate  # default Erlang install

# prompt ---------------------------------------------------------------------

export PS1="\[\033[35m\]λ\[\e[0m\] \W\[$txtcyn\]\$git_branch\[$txtred\]\$git_dirty\[$txtrst\] -> "

# aliases --------------------------------------------------------------------

# gooee
alias cloudapi='cd ~/gooee/cloud-api && source makeenv.sh'

# utilities
alias tmux="tmux -2"

# applications
alias crawl-tiles='/Applications/Dungeon\ Crawl\ Stone\ Soup\ -\ Tiles.app/Contents/MacOS/Dungeon\ Crawl\ Stone\ Soup\ -\ Tiles'

# colored output
alias ls='gls --color --group-directories-first'

# convenience
alias ..='cd ..'
alias ...='cd ...'
alias ll='ls -laF'
alias la='ls -a'
alias untmux='tmux kill-session'
alias python='python3'
alias pip='pip3'
alias vim='nvim'
alias evimrc='vim ~/.vimrc'
alias eviminit='vim ~/.config/nvim/init.vim'
alias ebashrc='vim ~/.bash_profile'
alias fay='stack exec fay -- '
alias r='robo'

# safety
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias ln='ln -i'

# git
alias git='hub'
alias gs='git status'
alias gd='git diff'
alias gl='git ll'
alias ga='git add'
alias gap='git add -p'
alias gc='git commit'
alias gca='git commit -a'
alias gp='git push'
alias gpu='git push -u origin $(git rev-parse --abbrev-ref HEAD)'
alias gu='git pull'
alias gb='git branch'
alias gch='git checkout'

# custom utilities -----------------------------------------------------------

gpx() {
    case $1 in
        stage|testcenter|prod)
            echo "don't force push to $1 pls"
            return 1 ;;
        *)
            git push -f origin $(git rev-parse --abbrev-ref HEAD):$1 ;;
    esac
}

delete-branch() {
    git branch -D $1 & git push origin :$1 
}

merge-latest() {
    git checkout $1 && git pull && git checkout - && git merge -
}

mkvenv() {
    if [[ -z $1 ]]; then
        env_dir="$HOME/.venvs/${PWD##*/}"
    else
        env_dir=$1
    fi
    python3 -m venv $env_dir
    source "$env_dir/bin/activate"
    pip install neovim ipython ipdb
    unset env_dir
}

venv() {
    if [[ -z $1 ]]; then
        dir=${PWD##*/}
    else
        dir="$1"
        cd "$HOME/projects/$dir" &>/dev/null || cd "$HOME/gooee/$dir"
    fi
    source $HOME/.venvs/$dir/bin/activate
    unset dir
}

# colored man pages ----------------------------------------------------------

man() {
    env \
            LESS_TERMCAP_mb=$(printf "\e[1;37m") \
            LESS_TERMCAP_md=$(printf "\e[1;37m") \
            LESS_TERMCAP_me=$(printf "\e[0m") \
            LESS_TERMCAP_se=$(printf "\e[0m") \
            LESS_TERMCAP_so=$(printf "\e[1;47;30m") \
            LESS_TERMCAP_ue=$(printf "\e[0m") \
            LESS_TERMCAP_us=$(printf "\e[0;36m") \
                    man "$@"
}

# tab completion -------------------------------------------------------------

complete -cf sudo
complete -cf man
complete -cf start
complete -cf stop
complete -cf restart
complete -cf reload
complete -cf spawn

# bash history ---------------------------------------------------------------

HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000

shopt -s histappend
shopt -s checkwinsize

# nvm ------------------------------------------------------------------------

export NVM_DIR="/Users/dtr/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

# virtualenv -----------------------------------------------------------------

export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
export WORKON_HOME=$HOME/.virtualenvs
source /usr/local/bin/virtualenvwrapper.sh
export PIP_VIRTUALENV_BASE=$WORKON_HOME

# docker ---------------------------------------------------------------------

function board () {
    docker exec -it "$1" bash
}

export PATH="$HOME/.cargo/bin:$PATH"

export VULKAN_SDK="$HOME/.vulkan_sdk/macOS"

export PATH="$VULKAN_SDK/bin:$PATH"

export DYLD_LIBRARY_PATH="$VULKAN_SDK/lib:$DYLD_LIBRARY_PATH"

export VK_ICD_FILENAMES="$VULKAN_SDK/etc/vulkan/icd.d/MoltenVK_icd.json"

export VK_LAYER_PATH="$VULKAN_SDK/etc/vulkan/explicit_layer.d"

export SHADERC_LIB_DIR="$VULKAN_SDK/lib"
