# -- 初期化スクリプトのキャッシュ -- #
#
# `eval "$(starship init zsh)"` のような初期化は、起動のたびにプロセスを起動するので遅い。
# 出力をファイルにキャッシュし、コマンド本体が更新されたときだけ作り直す。
#
#   _evalcache <名前> <コマンド...> && source $REPLY
#
# グローバルスコープで source するため、パスを $REPLY で返して呼び出し側で読み込む
# (関数内で source すると、スクリプト内の typeset がローカル変数になってしまう)。
#
#   zsh-cache-clear   キャッシュを消す (次回起動時に作り直される)

ZSH_CACHE_DIR=${XDG_CACHE_HOME:-$HOME/.cache}/zsh

function _evalcache() {
    local name=$1; shift
    local bin=${commands[$1]}
    [[ -n $bin ]] || return 1

    REPLY=$ZSH_CACHE_DIR/$name.zsh
    if [[ ! -s $REPLY || $bin -nt $REPLY ]]; then
        mkdir -p $ZSH_CACHE_DIR
        if ! "$@" >| $REPLY 2>/dev/null; then
            rm -f $REPLY
            return 1
        fi
    fi
}

function zsh-cache-clear() {
    rm -rf $ZSH_CACHE_DIR
    echo "zsh-cache-clear: $ZSH_CACHE_DIR を削除しました"
}
