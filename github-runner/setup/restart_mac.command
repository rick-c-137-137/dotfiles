#!/bin/bash

rm -rf .zsh_sessions
killall Runner\.Listener
sleep 3 & exit \
  & osascript -e 'tell application "Terminal" to set mainID to id of front window' \
    -e 'tell application "Terminal" to close (every window whose id ≠ mainID) without saving' \
  & osascript -e 'tell app "System Events" to restart' \
  & echo "$(date), restart mac"  >> "$HOME/Desktop/log_restart_mac.txt"

# set crobjob:
# (crontab -l 2>/dev/null; echo "0 5 * * 6 /bin/bash \$HOME/github-runner/setup/restart_mac.command") | crontab -
# get crobjob: crontab -l
# delete crobjob: crontab -r