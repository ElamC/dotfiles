# tab autocomplete/select
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist 
compinit
_comp_options+=(globdots)		# Include hidden files.

# working branch in prompt
function parse_branch() {
	local indicator
	git_status=$(git status --porcelain=v1 2> /dev/null | wc -l)
	[[ ! $git_status -eq "0" ]] && indicator=*
	git branch 2> /dev/null | sed -n -e "s/^\* \(.*\)/\1$indicator /p"
}
setopt PROMPT_SUBST
export PROMPT='%~ %{%F{245}%}$(parse_branch)%{%F{normal}%}$ %{%f%}'

# plugins
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/copydir/copydir.plugin.zsh

bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

alias python="/usr/local/bin/python3"
alias personal="cd ~/personal"
alias cdh="cd ~"
alias dls="docker ps -a"

# fzf alias
alias() {
	selected=$( builtin alias | sed 's/=.*//' | fzf )
	cmd="$( builtin alias $selected | sed -e "s/^[^=]*=//g" -e "s/\'//g" )"
	echo $cmd | grep -q "cd" && dir=$( echo $cmd | sed 's/[^ ]* //g' )
	if [[ -n $dir ]]; then
		eval cd $dir
	else
		eval $cmd
	fi
}

# Create .gitignore
giti() {
	list=$( find ~/bin/templates -type f -name '*.gitignore' | rev | cut -d\. -f2- | rev )
	echo $list | fzf --multi --delimiter / --with-nth -1 | awk '{print $1 ".gitignore"}' |
	while read -r line; do
		printf "#--$( echo $line | xargs basename -s .gitignore )--#\n";
		cat $line; printf "\n";
	done > $PWD/.gitignore
}

# cd to repo root
gitr() {
	if $( git rev-parse --is-inside-work-tree &> /dev/null ); then
		eval cd $(git rev-parse --show-toplevel)
	fi
}

copydir {
  pwd | tr -d "\r\n" | pbcopy
}

gitp() {
  # pull all remote branches
  for remote in `git branch -r`; do git branch --track ${remote#origin/} $remote; done
  git fetch --all
  git pull --all
}

tunnel() {
	ngrok http http://localhost:${1-8080}
}

# https://stackoverflow.com/questions/45141402/build-and-run-dockerfile-with-one-command/59220656#59220656
dbr() {
  docker build --no-cache . | tee /dev/tty | tail -n1 | cut -d' ' -f3 | xargs -I{} docker run --rm -i {}
}

work () {
	cd ~/work/$1
}

function _cdp () {
	((CURRENT == 2)) &&
  	_files -/ -W ~/${words}
}
compdef _cdp work personal

# Go
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$GOPATH/bin

#defaults write -g InitialKeyRepeat -int 10
#defaults write -g KeyRepeat -int 8