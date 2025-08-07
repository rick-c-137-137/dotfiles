#!/bin/bash

~/.local/bin/mise run --cd=$HOME/.config/mise restart:macos

# set crobjob:
# (crontab -l 2>/dev/null; echo "0 5 * * 6 /bin/bash \$HOME/github-runner/setup/restart_mac.command") | crontab -
# get crobjob: crontab -l
# delete crobjob: crontab -r