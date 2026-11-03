# -- ls -- #
alias ls="ls --color=auto"
alias l="ls"
alias ll="ls -lh"
alias la="ls -ah"

# -- 安全のため確認付きに -- #
alias rm="rm -i"
alias mv="mv -i"
alias cp="cp -i"

# -- Editor -- #
alias nv="nvim"
alias vi="nvim"

# -- Utilities -- #
alias le="less -N"
alias proot='cd "$(git rev-parse --show-toplevel)"'
alias lazygit='lazygit -ucd $HOME/.config/lazygit'
(( $+commands[wezterm] )) && alias imgcat="wezterm imgcat --width=auto"

# -- Clipboard -- #
if (( $+commands[pbcopy] )); then
    alias clip="pbcopy"
elif (( $+commands[wl-copy] )); then
    alias clip="wl-copy"
elif (( $+commands[xsel] )); then
    alias clip="xsel --clipboard --input"
fi

# -- kitty -- #
if [[ "$TERM" == "xterm-kitty" ]]; then
    alias s="kitty +kitten ssh"
    alias ssh="TERM=xterm-256color ssh"
fi
