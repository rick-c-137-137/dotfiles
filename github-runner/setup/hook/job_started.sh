#!/bin/sh

source ~/.zshrc
git config --global --unset credential.helper || true
git config --global --unset-all "http.https://github.com/.extraheader" || true
github-runner/setup/cleanup_runner_cache.sh debug_flag