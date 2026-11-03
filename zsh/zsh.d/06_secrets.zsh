# -- Secrets (Bitwarden CLI) -- #
#
# API キーなどは Bitwarden のセキュアメモに KEY=VALUE 形式で保存しておき、
# 必要なときに `bwenv` で環境変数に読み込む。
#
#   bwenv          アイテム "dotfiles-env" (BW_ENV_ITEM で変更可) を読み込む
#   bwenv <name>   指定したアイテムを読み込む
#   bwlock         環境変数を消して Bitwarden をロックする
#
# 初回だけ `bw login` が必要。ロックされていればマスターパスワードを聞かれる。

: ${BW_ENV_ITEM:=dotfiles-env}

function bwenv() {
    if (( ! $+commands[bw] )); then
        echo "bwenv: bw (Bitwarden CLI) が見つかりません" >&2
        return 1
    fi

    local item=${1:-$BW_ENV_ITEM}
    local bw_status
    bw_status=$(bw status 2>/dev/null)

    if [[ $bw_status == *'"status":"unauthenticated"'* ]]; then
        echo "bwenv: 先に bw login を実行してください" >&2
        return 1
    fi
    if [[ $bw_status != *'"status":"unlocked"'* ]]; then
        export BW_SESSION
        BW_SESSION=$(bw unlock --raw) || return 1
    fi

    bw sync >/dev/null 2>&1

    local notes
    notes=$(bw get notes "$item") || return 1

    local line key count=0
    typeset -ga _BWENV_KEYS
    while IFS= read -r line; do
        line=${line%$'\r'}
        [[ -z $line || $line == \#* || $line != *=* ]] && continue
        key=${line%%=*}
        export "$key=${line#*=}"
        _BWENV_KEYS+=($key)
        (( count++ ))
    done <<< "$notes"

    _BWENV_KEYS=(${(u)_BWENV_KEYS})
    echo "bwenv: $item から $count 個の環境変数を読み込みました"
}

function bwlock() {
    (( ${+_BWENV_KEYS} )) && unset $_BWENV_KEYS && unset _BWENV_KEYS
    (( $+commands[bw] )) && bw lock >/dev/null
    unset BW_SESSION
    echo "bwlock: 環境変数を消して Bitwarden をロックしました"
}
