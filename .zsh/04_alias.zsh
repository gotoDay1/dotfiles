alias ls="ls --color"
alias l="ls --color" alias ll="ls -lh --color"
alias la="ls -ah --color"
alias rm="rm -i"
alias mv="mv -i"
alias cp="cp -i"
alias le="less -N"
alias nv="nvim"
alias vi="nvim"
alias imgcat="wezterm imgcat --width=auto"
if command -v xsel &> /dev/null; then
    alias clip="xsel --clipboard --input"
fi

if [ $(echo $TERM) = "xterm-kitty" ]; then
    alias s="kitty +kitten ssh"
    alias ssh="TERM=XTERM /usr/bin/ssh"
fi

