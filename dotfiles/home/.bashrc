# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

## Starship
eval "$(starship init bash)"

## Zoxide
eval "$(zoxide init --cmd cd bash)"

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
source <(fzf --bash) #CTRL R for fuzzy history finder
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
alias gclone='git clone'
alias gcommit='git commit'
alias gpull='git pull'
alias gpush='git push'
alias gadd='git add .'
alias gstat='git status'

# Applications
alias v='nvim'
alias sv='sudo nvim'

