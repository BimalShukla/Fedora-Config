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
alias update='sudo dnf update'
alias install='sudo dnf install'
alias remove='sudo dnf remove'
alias clean='sudo dnf clean all'
alias src='dnf search'
alias autoclean='sudo dnf autoremove && clean all'

# COPR
alias cenable='sudo dnf copr enable'
alias cdisable='sudo dnf copr disable'
alias cremove='sudo dnf copr remove'
alias clist='dnf copr list'

# Flatpak
alias fplist='flatpak list'
alias fpupdate='sudo flatpak update'
alias fpinstall='sudo flatpak install'
alias fpremove='sudo flatpak uninstall'

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

# LazyGIT
alias lg='lazygit'

# GIT
alias gc='git clone'
alias gs='git status'

# Applications
alias v='nvim'
alias sv='sudo nvim'

