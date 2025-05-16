#!/bin/bash

rm -rf .zsh_sessions
killall Runner\.Listener
sleep 3
# 關掉全部 Terminal, 然後讓 macos 重開機.
exit & osascript -e 'tell application "Terminal" to set mainID to id of front window' -e 'tell application "Terminal" to close (every window whose id ≠ mainID) without saving' & osascript -e 'tell app "System Events" to restart'
