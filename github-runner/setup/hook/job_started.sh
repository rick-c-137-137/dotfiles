#!/bin/sh

source ~/.zshrc
git config --global --unset credential.helper || true
git config --global --unset-all "http.https://github.com/.extraheader" || true