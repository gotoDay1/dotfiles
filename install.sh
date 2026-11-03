#!/usr/bin/env bash
#
# dotfiles installer
#
#   ./install.sh            シンボリックリンクを作成し、依存関係をチェックする
#   ./install.sh --dry-run  実際には何も変更せず、実行内容だけを表示する
#   ./install.sh --no-deps  依存関係のチェック・deno の自動インストールを省略する
#
# 既存のファイル/ディレクトリ(シンボリックリンク以外)は削除せず
# ~/.dotfiles_backup/<日時>/ に退避してからリンクを張る。

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"
DRY_RUN=0
CHECK_DEPS=1

for arg in "$@"; do
    case "$arg" in
        -n | --dry-run) DRY_RUN=1 ;;
        --no-deps) CHECK_DEPS=0 ;;
        -h | --help)
            sed -n '2,10p' "$0" | sed 's/^# \{0,1\}//'
            exit 0
            ;;
        *)
            echo "Unknown option: $arg" >&2
            exit 1
            ;;
    esac
done

case "$(uname -s)" in
    Darwin) OS=mac ;;
    Linux) OS=linux ;;
    *) OS=other ;;
esac

run() {
    if [ "$DRY_RUN" -eq 1 ]; then
        echo "[dry-run] $*"
    else
        "$@"
    fi
}

# $1: リポジトリ内のパス, $2: リンクの作成先
link() {
    local src="$DOTFILES_DIR/$1"
    local dest="$2"

    if [ ! -e "$src" ]; then
        echo "⚠️  $1 not found in repository, skipping"
        return
    fi

    if [ -L "$dest" ]; then
        if [ "$(readlink "$dest")" = "$src" ]; then
            echo "✔  $dest (already linked)"
            return
        fi
        run rm "$dest"
    elif [ -e "$dest" ]; then
        echo "📦 backup: $dest -> $BACKUP_DIR/"
        run mkdir -p "$BACKUP_DIR"
        run mv "$dest" "$BACKUP_DIR/"
    fi

    run mkdir -p "$(dirname "$dest")"
    run ln -s "$src" "$dest"
    echo "🔗 $dest -> $src"
}

# ---------------------------------------------------------------------------
# submodule (alacritty themes)
# ---------------------------------------------------------------------------
if [ -f "$DOTFILES_DIR/.gitmodules" ] && command -v git &>/dev/null; then
    echo "==> Updating git submodules..."
    run git -C "$DOTFILES_DIR" submodule update --init --recursive || true
fi

# ---------------------------------------------------------------------------
# zsh
# ---------------------------------------------------------------------------
echo "==> Linking zsh files..."
link .zshrc "$HOME/.zshrc"
for file in "$DOTFILES_DIR"/.zsh/*; do
    link ".zsh/$(basename "$file")" "$HOME/.zsh/$(basename "$file")"
done
# リポジトリから削除されたファイルへのリンク切れを掃除
for file in "$HOME"/.zsh/*; do
    if [ -L "$file" ] && [ ! -e "$file" ]; then
        case "$(readlink "$file")" in
            "$DOTFILES_DIR"/*)
                echo "🧹 remove broken link: $file"
                run rm "$file"
                ;;
        esac
    fi
done

# ---------------------------------------------------------------------------
# ホームディレクトリ直下
# ---------------------------------------------------------------------------
echo "==> Linking dotfiles to home directory..."
for file in .tmux.conf .fprettify.rc; do
    link "$file" "$HOME/$file"
done
if [ "$OS" = mac ]; then
    link .latexmkrc_mac "$HOME/.latexmkrc"
fi

# ---------------------------------------------------------------------------
# ~/.config
# ---------------------------------------------------------------------------
echo "==> Linking config directories..."
configs=(nvim sheldon wezterm alacritty ghostty lazygit yazi)
[ "$OS" = linux ] && configs+=(rofi)
for config in "${configs[@]}"; do
    link ".config/$config" "$HOME/.config/$config"
done

# ---------------------------------------------------------------------------
# scripts
# ---------------------------------------------------------------------------
if [ "$OS" = linux ]; then
    echo "==> Linking scripts..."
    for file in "$DOTFILES_DIR"/scripts/*; do
        link "scripts/$(basename "$file")" "$HOME/.scripts/$(basename "$file")"
    done
fi

# ---------------------------------------------------------------------------
# 依存関係のチェック
# ---------------------------------------------------------------------------
if [ "$CHECK_DEPS" -eq 1 ]; then
    echo "==> Checking dependencies..."
    required=(zsh nvim git sheldon tmux)
    optional=(mise uv cargo fzf lazygit yazi wezterm ghostty alacritty deno)
    [ "$OS" = linux ] && optional+=(rofi xsel)

    missing=0
    for dep in "${required[@]}"; do
        if command -v "$dep" &>/dev/null; then
            echo "✅ $dep"
        else
            echo "❌ $dep (required)"
            missing=$((missing + 1))
        fi
    done
    for dep in "${optional[@]}"; do
        if command -v "$dep" &>/dev/null; then
            echo "✅ $dep"
        else
            echo "➖ $dep (optional)"
        fi
    done

    # Deno (ddc.vim / skkeleton で使用)
    if ! command -v deno &>/dev/null && [ ! -x "$HOME/.deno/bin/deno" ]; then
        echo "==> Installing deno..."
        if [ "$DRY_RUN" -eq 1 ]; then
            echo "[dry-run] curl -fsSL https://deno.land/install.sh | sh"
        elif curl -fsSL https://deno.land/install.sh | sh; then
            echo "✅ deno installed"
        else
            echo "❌ failed to install deno"
        fi
    fi

    if [ "$missing" -gt 0 ]; then
        echo "⚠️  $missing required dependencies are missing."
        [ "$OS" = mac ] && echo "    brew bundle --file=$DOTFILES_DIR/macos/Brewfile"
    else
        echo "🎉 All required dependencies are installed!"
    fi
fi

# ---------------------------------------------------------------------------
# ローカル設定
# ---------------------------------------------------------------------------
if [ ! -e "$HOME/.zshrc.local" ]; then
    echo "==> Creating ~/.zshrc.local from template..."
    run cp "$DOTFILES_DIR/templates/zshrc.local.example" "$HOME/.zshrc.local"
fi

echo "Installation completed!"
