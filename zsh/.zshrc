# Tab autocomplete/select
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist 
compinit
_comp_options+=(globdots)		# Include hidden files.

# Display working branch in prompt
function parse_branch() {
	local SYMBOL
	GIT_STATUS=$(git status --porcelain=v1 2> /dev/null | wc -l)
    [[ ! $GIT_STATUS -eq "0" ]] && SYMBOL=*
	git branch 2> /dev/null | sed -n -e "s/^\* \(.*\)/git:\1$SYMBOL /p"
}
setopt PROMPT_SUBST
export PROMPT='%{%F{normal}%}%n %{%F{39}%}@%{%F{normal}%} %~ %{%F{245}%}$(parse_branch)%{%F{normal}%}$ %{%f%}'

# Load zsh-autosuggestions
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
# Load aliases
source ~/.config/alias

# Go
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$GOPATH/bin
