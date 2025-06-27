#!/bin/bash

set -e

MODE="${1:-disk_space}"  # 支援 'disk_space' (預設) 或 'debug_flag'

function log {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"
}

function cleanup_disk_space {
    log "🧹 Cleaning system & development caches..."

    # System
    rm -rf "/private/var/tmp/SpeechModelCache/" || true
    rm -rf ~/vendor/DerivedData || true
    rm -rf /private/var/folders/* || true

    # Xcode
    log "🔧 Cleaning Xcode caches..."
    # rm -rf ~/vendor/DerivedData || true
    rm -rf ~/Library/Developer/Xcode/{DerivedData,Archives,Logs} || true
    xcrun simctl delete all || true

    # Android
    log "📱 Cleaning Android caches..."
    rm -rf ~/.gradle/caches/ || true
    rm -rf ~/.android/build-cache/ || true
    rm -rf ~/.kotlin/daemon/ || true

    log "✅ Cleanup completed."
}

function check_disk_space {
    local threshold_gb=30
    local available_kb=$(df -P / | awk 'NR==2 {print $4}')
    local available_gb=$(echo "scale=2; $available_kb / 1000000" | bc)

    log "📦 Available disk: ${available_gb} GB (Threshold: ${threshold_gb} GB)"

    if (( $(echo "$available_gb < $threshold_gb" | bc -l) )); then
        log "⚠️  Disk below threshold, running cleanup..."
        cleanup_disk_space
    else
        log "✅ Disk space sufficient, skipping cleanup."
    fi
}

function check_debug_flag {
    log "🧪 RUNNER_DEBUG: $RUNNER_DEBUG"
    if [[ "$RUNNER_DEBUG" == "1" ]]; then
        log "🪲 RUNNER_DEBUG is set, cleaning..."
        cleanup_disk_space
    else
        log "✅ RUNNER_DEBUG not set, skipping cleanup."
    fi
}

function is_monitored_runner {
    for name in $PINKOI_RUNNER_NAMES; do
        if [[ "$name" == "$RUNNER_NAME" ]]; then
            return 0
        fi
    done
    return 1
}

function cleanup_runner_cache {
    if is_monitored_runner; then
        case "$MODE" in
            disk_space)
                check_disk_space
                ;;
            debug_flag)
                check_debug_flag
                ;;
            *)
                log "❌ Invalid mode: '$MODE'. Use 'disk_space' or 'debug_flag'."
                exit 1
                ;;
        esac
    else
        log "🛑 '$RUNNER_NAME' not in monitored runners. Skipping cleanup."
    fi
}

cleanup_runner_cache
