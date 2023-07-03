# If you come from bash you might have to change your $PATH.

# Path to your oh-my-zsh installation.
export ZSH="/Users/alix/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  fzf-yarn
)

source $ZSH/oh-my-zsh.sh

eval "$(rbenv init - zsh)"
# User configuration

export PATH="$PATH:$HOME/.rvm/bin"
export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-11.jdk/Contents/Home
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$ANDROID_HOME/emulator:$PATH
export PATH=$ANDROID_HOME/tools:$PATH
export PATH=$ANDROID_HOME/tools/bin:$PATH
export PATH=$ANDROID_HOME/platform-tools:$PATH
export PATH=~/flutter/bin:$PATH
export PATH=/usr/local/opt/kubernetes-cli@1.22/bin:$PATH


# Rajoute plein de commandes trop bien pour fzf (merci Ppou)
plugins=(... fzf-yarn ...)
export FZF_COMPLETION_TRIGGER=","

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


# FZF functions

# Pipe command to fzf. f <cmd>
f(){
  "$@" | fzf
}


fg() {
  git log --graph --color=always \
      --bind "ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                {}
                FZF-EOF"
}

# fr - Select commit to rebase onto
fr() {
  git log --graph --color=always --format="%h%C(#ff69b4)%d%C(reset) %s" "$@" | fzf --ansi --reverse --tiebreak=index | grep -o '[a-f0-9]\{7\}' | awk '{print $1"^"}' | xargs -o git rebase -i
}

# autofix amend a commit in the past
autofixup() {!f() { COMMIT=$(git log --pretty=oneline | fzf | awk '{print $1}'); git commit --fixup $COMMIT; GIT_SEQUENCE_EDITOR=: git rebase --autostash --autosquash -i $COMMIT^; }; f}
