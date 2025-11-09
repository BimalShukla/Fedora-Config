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

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

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

# Command
alias ls='eza -F --icons'
alias ll='eza -lF --icons'
alias la='eza -aF --icons'
alias lla='eza -laF --icons'
alias gc='git clone'
alias v='nvim'
alias cat='bat'
