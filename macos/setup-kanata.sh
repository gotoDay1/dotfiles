#!/usr/bin/env bash
#
# macOS で kanata を起動時に常駐させる (LaunchDaemon, root で実行)
#
# 事前に必要なもの:
#   - kanata 本体             : brew install kanata
#   - Karabiner VirtualHIDDevice ドライバ:
#       kanata のリリースノートで指定されているバージョンの
#       Karabiner-DriverKit-VirtualHIDDevice の .pkg を入れ、
#       Karabiner-VirtualHIDDevice-Manager でドライバを有効化する
#   - システム設定 > プライバシーとセキュリティ > 入力監視 で kanata を許可

set -euo pipefail

KANATA="$(command -v kanata || true)"
if [ -z "$KANATA" ]; then
    echo "kanata が見つかりません。brew install kanata でインストールしてください。" >&2
    exit 1
fi
CONFIG="$HOME/.config/kanata/kanata.kbd"
LABEL="local.kanata"
PLIST="/Library/LaunchDaemons/$LABEL.plist"

sudo tee "$PLIST" >/dev/null <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>$LABEL</string>
    <key>ProgramArguments</key>
    <array>
        <string>$KANATA</string>
        <string>--cfg</string>
        <string>$CONFIG</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardOutPath</key>
    <string>/tmp/kanata.log</string>
    <key>StandardErrorPath</key>
    <string>/tmp/kanata.log</string>
</dict>
</plist>
PLIST
sudo chown root:wheel "$PLIST"
sudo chmod 644 "$PLIST"

sudo launchctl bootout system "$PLIST" 2>/dev/null || true
sudo launchctl bootstrap system "$PLIST"

echo "完了。ログ: /tmp/kanata.log"
echo "停止: sudo launchctl bootout system $PLIST"
