# -- Key bindings -- #
bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward

# -- lf: 終了時のディレクトリに cd する -- #
# `lf` を打つだけで、lf を閉じたときにそのディレクトリへ移動する (公式の lfcd と同じ仕組み)
function lf() {
    cd "$(command lf -print-last-dir "$@")"
}
