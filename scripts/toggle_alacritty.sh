#!/bin/bash

# AlacrittyウィンドウのIDを取得する
window_id=$(xdo id -n Alacritty)

if [ -n "$window_id" ]; then
    # ウィンドウのスタック順序を確認
    active_window=$(xprop -root _NET_ACTIVE_WINDOW | awk '{print $5}')

    # ウィンドウIDをゼロパディングして比較
    window_id_padded=$(printf "%x" "$window_id")
    active_window_padded=$(printf "%x" "$active_window")

    if [ "$window_id_padded" = "$active_window_padded" ]; then
        # ウィンドウが最前面にある場合、隠す
        xdo hide -n Alacritty
    else
        # ウィンドウが最前面にない場合、前面に表示する
        xdo show -n Alacritty
        wmctrl -ia "$window_id"
    fi
else
    # Alacrittyが存在しない場合、新しいインスタンスを起動する
    alacritty &
fi
