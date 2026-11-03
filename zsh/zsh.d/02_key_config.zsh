# -- Key bindings -- #
bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward

# -- yazi: 終了時のディレクトリに cd する -- #
function y() {
    local tmp cwd
    tmp="$(mktemp -t "yazi-cwd.XXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}
