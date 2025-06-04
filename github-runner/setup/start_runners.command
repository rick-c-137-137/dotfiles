#!/bin/bash

# This script is used to redeploy the GitHub Runner, with `pmset` implemented to restart the Runner at a specific time. 
#
# Please follow the steps below for configuration:
#   1. Check if `pmset` has a restart time configured.
#   2. Set the restart time.
#   3. Go to General -> Login Items -> Select this script from iCloud to set it as a startup item after login.
#
# * To view existing schedules: pmset -g sched 
# * Set a restart time, e.g., every Saturday at 5:00 AM: sudo pmset repeat restart S 05:00:00

# find and deploy github runners 
# e.g. ~/github-runner/20230726125546/actions-runner/run.sh

find ~/github-runner -maxdepth 3 -type f -name "run.sh" | while read script; do
  echo $script
  osascript -e "tell app \"Terminal\" to do script \"cd $(dirname $script); ./run.sh\""
  sleep 1
done

exit