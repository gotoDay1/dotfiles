#!/usr/bin/env bash
#
# Linux で kanata を sudo なしで常駐させる (systemd ユーザーサービス)
#   1. uinput グループを作成し、自分を input / uinput グループに追加
#   2. /dev/uinput のアクセス権を udev ルールで設定
#   3. ~/.config/systemd/user/kanata.service を作成して有効化
# 実行後、グループ反映のために一度ログアウト/再起動が必要。

set -euo pipefail

KANATA="$(command -v kanata || true)"
if [ -z "$KANATA" ]; then
    echo "kanata が見つかりません。brew install kanata か cargo install kanata でインストールしてください。" >&2
    exit 1
fi
CONFIG="$HOME/.config/kanata/kanata.kbd"

echo "==> uinput / input グループの設定 (sudo)"
getent group uinput >/dev/null || sudo groupadd --system uinput
sudo usermod -aG input,uinput "$USER"

echo "==> udev ルールの設定 (sudo)"
echo 'KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"' |
    sudo tee /etc/udev/rules.d/99-input.rules >/dev/null
sudo udevadm control --reload-rules
sudo udevadm trigger
sudo modprobe uinput

echo "==> systemd ユーザーサービスの作成"
mkdir -p "$HOME/.config/systemd/user"
cat >"$HOME/.config/systemd/user/kanata.service" <<UNIT
[Unit]
Description=kanata keyboard remapper

[Service]
Type=simple
ExecStart=$KANATA --cfg $CONFIG
Restart=on-failure
RestartSec=3

[Install]
WantedBy=default.target
UNIT

systemctl --user daemon-reload
systemctl --user enable kanata.service

echo "完了。ログアウト/再起動後に kanata が自動起動します。"
echo "状態確認: systemctl --user status kanata"
