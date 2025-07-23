#!/bin/bash

# 簡單的 log 函數
function log {
    local message="[$(date +'%Y-%m-%d %H:%M:%S')] $*"
    echo "$message"
    echo "$message" >> "$HOME/Desktop/log.txt"
}

log "🔄 Mac restart initiated"

rm -rf .zsh_sessions
killall Runner\.Listener
sleep 3

# 關掉全部 Terminal, 然後讓 macos 重開機
exit & osascript -e 'tell application "Terminal" to set mainID to id of front window' -e 'tell application "Terminal" to close (every window whose id ≠ mainID) without saving' & osascript -e 'tell app "System Events" to restart'

# set crobjob:
# (crontab -l 2>/dev/null; echo "0 5 * * 6 /bin/bash \$HOME/github-runner/setup/restart_mac.command") | crontab -
# get crobjob: crontab -l
# delete crobjob: crontab -r