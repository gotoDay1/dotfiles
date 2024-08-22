# -- Zsh -- #
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'
setopt auto_cd
#autoload predict-off
autoload -U compinit && compinit -u
autoload -Uz colors
setopt print_eight_bit
setopt no_beep
setopt nolistbeep
setopt auto_pushd
setopt share_history
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
zstyle ':completion:*:default' menu select=1
setopt correct
setopt extended_glob
bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward

# vcs_info
autoload -Uz vcs_info
autoload -Uz add-zsh-hook

zstyle ':vcs_info:*' formats '%F{green}(%s)-[%b]%f'
zstyle ':vcs_info:*' actionformats '%F{red}(%s)-[%b|%a]%f'

function _update_vcs_info_msg() {
    LANG=en_US.UTF-8 vcs_info
    RPROMPT="${vcs_info_msg_0_}"
}

# 履歴ファイルの保存先
export HISTFILE=${HOME}/.zsh_history

# メモリに保存される履歴の件数
export HISTSIZE=1000

# 履歴ファイルに保存される履歴の件数
export SAVEHIST=100000

# 重複を記録しない
setopt hist_ignore_dups

# 開始と終了を記録
setopt EXTENDED_HISTORY

