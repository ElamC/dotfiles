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
	git branch 2> /dev/null | sed -n -e "s/^\* \(.*\)/git:\1$indicator /p"
}
setopt PROMPT_SUBST
export PROMPT='%{%F{normal}%}%n %{%F{39}%}@%{%F{normal}%} %~ %{%F{245}%}$(parse_branch)%{%F{normal}%}$ %{%f%}'

# zsh-autosuggestions
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
# aliases
source ~/.config/alias

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
	list=$( find ~/.config/templates -type f -name '*.gitignore' | rev | cut -d\. -f2- | rev )
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

tunnel() {
	eval 'ngrok http https://localhost:${1-8080}'
}

function _cdp () {
	((CURRENT == 2)) &&
  	_files -/ -W ~/work
}
work() {
  eval cd "~/work/$1"
}
compdef _cdp work

# Go
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$GOPATH/bin
