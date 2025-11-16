# Created by newuser for 5.9

## Plugins
source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
fpath+=~/.zsh/plugins/zsh-completions/src



## History
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt appendhistory
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

# Fix Home and End key bindings
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[3~" delete-char

## Starship
eval "$(starship init zsh)"

## Zoxide
eval "$(zoxide init --cmd cd zsh)"

## Fastfetch
fastfetch

## YAZI
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

## User Defined Aliases
# DNF
alias upg= 'sudo dnf upgrade --refresh'
alias upd='sudo dnf update'
alias ins='sudo dnf install'
alias rmv='sudo dnf remove'
alias clean='sudo dnf clean all'
alias src='dnf search'
alias autoclean='sudo dnf autoremove && clean all'
alias autormv='sudo dnf autoremove'

# COPR
alias cenable='sudo dnf copr enable'
alias cdisable='sudo dnf copr disable'
alias cremove='sudo dnf copr remove'
alias clist='dnf copr list'

# FZF
source <(fzf --zsh) #CTRL R for fuzzy history finder
alias ff='fzf'
alias ffm='fzf --multi'

# Command
# ls command
alias ls='eza -F --icons'
alias ll='eza -lF --icons'
alias la='eza -aF --icons'
alias lla='eza -laF --icons'

# GIT
alias gclo='git clone'
alias gcom='git commit'
alias gpul='git pull'
alias gpus='git push'
alias gadd='git add .'
alias gsta='git status'

# Applications
alias v='nvim'
alias sv='sudo nvim'

