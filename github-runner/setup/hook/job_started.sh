#!/bin/sh

source ~/.zshrc
# git config --global --unset credential.helper || true
# git config --global --unset-all "http.https://github.com/.extraheader" || true
git config --global credential.helper ""
sh ~/github-runner/setup/cleanup_runner_cache.sh debug_flag