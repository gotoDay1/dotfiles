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
abbr -S -q lzdo='lazydocker'

if [ -f ~/.zshrc.local ]; then
    source ~/.zshrc.local
fi
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/sg/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/Caskroom/miniconda/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

