# -- Options -- #
setopt auto_cd
setopt auto_pushd
setopt correct
setopt extended_glob
setopt print_eight_bit
setopt no_beep
setopt nolistbeep

# -- Completion style -- #
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'
zstyle ':completion:*:default' menu select=1
autoload -Uz colors && colors

# -- History -- #
export HISTFILE=${HOME}/.zsh_history
export HISTSIZE=1000       # メモリに保存される履歴の件数
export SAVEHIST=100000     # 履歴ファイルに保存される履歴の件数
setopt share_history
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt extended_history    # 開始と終了を記録

# -- Secrets (API keys など) -- #
# ~/.env は git 管理外。KEY=VALUE 形式で記述する
if [[ -r ~/.env ]]; then
    set -a
    source ~/.env
    set +a
fi

# -- mise (ランタイムバージョン管理) -- #
if (( $+commands[mise] )); then
    eval "$(mise activate zsh)"
fi
