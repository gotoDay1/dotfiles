prompt='
%m : %F{green}%~%f 
$ '

#export LSCOLORS=gxfxcxdxbxegedabagacad

ZSHHOME="${HOME}/.zsh"

if [ -d $ZSHHOME -a -r $ZSHHOME -a \
     -x $ZSHHOME ]; then
     for i in $ZSHHOME/*; do
         [[ ${i##} = *.zsh ]] && 
         [ \( -f $i -o -h $i \) -a -r $i ] && . $i
     done 
fi

fpath+=($HOME/.local/share/sheldon/repos/github.com/*)
eval "$(sheldon source)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
abbr -S -q lg='lazygit'
