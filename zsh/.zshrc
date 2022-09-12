# Tab autocomplete/select
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist 
compinit
_comp_options+=(globdots)		# Include hidden files.

# Display working branch in prompt
function parse_branch() {
	local indicator
	git_status=$(git status --porcelain=v1 2> /dev/null | wc -l)
	[[ ! $git_status -eq "0" ]] && indicator=*
	git branch 2> /dev/null | sed -n -e "s/^\* \(.*\)/git:\1$indicator /p"
}
setopt PROMPT_SUBST
export PROMPT='%{%F{normal}%}%n %{%F{39}%}@%{%F{normal}%} %~ %{%F{245}%}$(parse_branch)%{%F{normal}%}$ %{%f%}'

# Load zsh-autosuggestions
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
# Load aliases
source ~/.config/alias

# Override default alias with fuzzy finder
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

# Git branch select 
gits() {
	git branch | fzf | sed 's/\* //g' | xargs -I '{}' git checkout {}
}

# Create .gitignore
giti() {
	list=$( find ~/desktop/templates -type f -name '*.gitignore' | cut -d\. -f1 )
	echo $list | fzf --multi --delimiter / --with-nth -1 | awk '{print $1 ".gitignore"}' |
	while read -r line; do 
		printf "#--$( echo $line | xargs basename -s .gitignore )--#\n";
		cat $line; printf "\n";
	done > test.gitignore
}

# Go
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$GOPATH/bin
