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
if [ -f ~/.zshrc.local ]; then
    echo "activate .zshrc.local"
    source ~/.zshrc.local
else
    echo "NOT FOUND .zshrc.local"
fi

fpath+=($HOME/.local/share/sheldon/repos/github.com/*)
eval "$(sheldon source)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
abbr -S -q lg='lazygit'
abbr -S -q lzdo='lazydocker'

# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/sg/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions
