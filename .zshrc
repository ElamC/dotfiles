autoload -U compinit
compinit
setopt globdots       # include hidden files.
zstyle ':completion:*' menu select

# plugins
source ~/.zsh/fzf-tab/fzf-tab.zsh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

git_prompt() {
    local dirty
	[[ ! $(git status --porcelain=v1 2> /dev/null | wc -l) -eq "0" ]] && dirty=*
	git branch 2> /dev/null | sed -n -e "s/^\* \(.*\)/git:\1$dirty /p"
}
ssh_conn_str() {
    [[ -n $SSH_CONNECTION ]] && echo "[%n%f@%m%f] "
}
setopt promptsubst
export PROMPT='$(ssh_conn_str)%~ %{%F{245}%}$(git_prompt)%{%F{normal}%}φ %{%f%}'

alias hs='history 1 | grep'
alias docker="podman"
alias dls="docker ps -a"
alias ls="ls -a -G"
alias ze='nvim ~/.zshrc'
alias zs='source ~/.zshrc'

# git 
alias grr='cd "$(git rev-parse --show-toplevel)"'   # to repo root
alias gca='git commit -a --amend'
alias gc='git checkout $(git branch | fzf | sed "s/^[ *]*//g")'
alias gs='git status -s'
alias gr='git status -s | awk "{print \$2}" | fzf -m | xargs git restore'
alias gl='git log --all --graph --format=oneline'
alias gcm="git fetch -p && git for-each-ref --format '%(refname:short) %(upstream:track)' | awk '\$2 == \"[gone]\" {print \$1}' | xargs -r git branch -D"
# [u]pdate [l]ocal
gul() {
    for b in `git branch -r | grep -v -- '->'`; do 
        git branch --track ${b##origin/} $b; 
    done && git pull --all
}
# [p]ull request check[o]ut
gpo() {
  gh pr list --author "@me" | fzf --header 'checkout PR' | awk '{print $(NF-5)}' | xargs git checkout
}

alias tma='tmux attach -t'
alias tmn='tmux new -s'
alias tmm='tmux new -ADs main'
alias tmk="tmux ls | fzf-tmux | cut -d':' -f1 | xargs tmux kill-session -t"

# safe defaults
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'

# history
export HISTFILE=~/.zsh_history
export HISTORY_IGNORE="(clear|ls)"
export HISTSIZE=50000
export SAVEHIST=50000
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_find_no_dups
setopt hist_save_no_dups
setopt inc_append_history
setopt share_history
setopt auto_pushd
setopt autocd
unsetopt flowcontrol

# open command in vim
autoload edit-command-line; zle -N edit-command-line
bindkey -M vicmd ' ' edit-command-line

cpd() {
    pwd | tr -d "\r\n" | pbcopy
}

mkcd() {
    mkdir -p $1 && cd $1
}

tunnel() {
    lt --port ${1-8080} --subdomain lh$(shuf -i 49152-65535 -n1)
}

# https://stackoverflow.com/questions/45141402/build-and-run-dockerfile-with-one-command/59220656#59220656
dbr() {
    docker build --no-cache . | tee /dev/tty | tail -n1 | cut -d' ' -f3 | xargs -I{} docker run --rm -i {}
}

dcls() {
    docker ps -a -q | xargs docker kill -f
    docker ps -a -q | xargs docker rm -f
    docker images | grep "none" | awk '{print $3}' | xargs docker rmi -f
    docker volume prune -f
}

# vim mode
bindkey -v
export KEYTIMEOUT=10
bindkey -M viins 'kj' vi-cmd-mode
bindkey -M vicmd '^A' vi-beginning-of-line
bindkey -M vicmd '^E' vi-end-of-line

bindkey '^P' history-search-backward
bindkey '^N' history-search-forward
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey '^W' backward-kill-word
bindkey '^Q' push-line-or-edit
# ctrl+space to accept
bindkey '^ ' autosuggest-accept 
# backspace fix
bindkey '^?' backward-delete-char
bindkey '^[[3~' delete-char

export EDITOR="nvim"
# Go
export PATH=$PATH:/usr/local/go/bin
# fzf
export FZF_DEFAULT_OPTS="--border sharp --layout=reverse --bind ctrl-u:preview-up,ctrl-d:preview-down,tab:accept"
zstyle ':fzf-tab:*' fzf-bindings 'tab:accept'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# neovim for manpages
export MANPAGER='nvim +Man!'
export MANWIDTH=999
