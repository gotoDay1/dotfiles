bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward

alias lazygit='lazygit -ucd $HOME/.config/lazygit'

function y() {
    tmp="$(mktemp -t "yazi-cwd.XXXXX")"
    yazi --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

