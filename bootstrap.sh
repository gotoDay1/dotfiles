#!/usr/bin/env bash
#
# 新しいマシン (macOS / Linux) を 1 行でセットアップする
#
#   curl -fsSL https://raw.githubusercontent.com/gotoDay1/dotfiles/main/bootstrap.sh | bash
#   curl -fsSL https://raw.githubusercontent.com/gotoDay1/dotfiles/main/bootstrap.sh | bash -s -- --packages
#
#   --packages  Homebrew (無ければインストール) で Brewfile のパッケージも入れる
#   その他の引数は install.sh にそのまま渡す (--dry-run など)
#
# 環境変数
#   DOTFILES_DIR     clone 先 (既定: ~/dotfiles)
#   DOTFILES_BRANCH  ブランチ (既定: main)

set -euo pipefail

REPO_URL="https://github.com/gotoDay1/dotfiles.git"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
DOTFILES_BRANCH="${DOTFILES_BRANCH:-main}"

PACKAGES=0
args=()
for arg in "$@"; do
    case "$arg" in
        --packages) PACKAGES=1 ;;
        *) args+=("$arg") ;;
    esac
done

if ! command -v git &>/dev/null; then
    echo "git が見つかりません。" >&2
    case "$(uname -s)" in
        Darwin) echo "xcode-select --install を実行してから再実行してください。" >&2 ;;
        *) echo "パッケージマネージャーで git を入れてから再実行してください (例: sudo apt install -y git)。" >&2 ;;
    esac
    exit 1
fi

if [ -d "$DOTFILES_DIR/.git" ]; then
    echo "==> Updating $DOTFILES_DIR"
    git -C "$DOTFILES_DIR" pull --ff-only
else
    echo "==> Cloning into $DOTFILES_DIR"
    git clone --branch "$DOTFILES_BRANCH" "$REPO_URL" "$DOTFILES_DIR"
fi

if [ "$PACKAGES" -eq 1 ]; then
    if ! command -v brew &>/dev/null; then
        echo "==> Installing Homebrew"
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    for brew in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
        if [ -x "$brew" ]; then
            eval "$("$brew" shellenv)"
            break
        fi
    done
    echo "==> brew bundle"
    brew bundle --file="$DOTFILES_DIR/Brewfile"
fi

# bash 3.2 (macOS) で空配列を set -u で展開するとエラーになるため ${args[@]+...} を使う
exec "$DOTFILES_DIR/install.sh" ${args[@]+"${args[@]}"}
