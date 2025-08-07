#!/bin/sh

function is_monitored_runner {
    for name in $PINKOI_RUNNER_NAMES; do
        if [[ "$name" == "$RUNNER_NAME" ]]; then
            return 0
        fi
    done
    if [[ "Pinkoi-App" == "$RUNNER_NAME" ]]; then
        return 0
    fi
    return 1
}

function cleanup_runner_cache {
    if is_monitored_runner; then
        ~/.local/bin/mise implode --yes || true
        ~/.local/share/mise/bin/mise implode --yes || true
    else
        log "🛑 '$RUNNER_NAME' not in monitored runners. Skipping cleanup."
    fi
}

cleanup_runner_cache
