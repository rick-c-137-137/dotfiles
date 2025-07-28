#!/bin/bash

set -e

MODE="${1:-disk_space}"  # 支援 'disk_space' (預設) 或 'debug_flag'

# 簡單的 log 函數
function log {
    local message="[$(date +'%Y-%m-%d %H:%M:%S')] $*"
    echo "$message"
    echo "$message" >> "$HOME/Desktop/log.txt"
}

function cleanup_disk_space {
    log "🧹 Starting cache cleanup..."
    
    # 記錄清理前的磁碟空間
    local before_kb=$(df -P / | awk 'NR==2 {print $4}')
    local before_gb=$(echo "scale=2; $before_kb / 1000000" | bc)
    log "📦 Before cleanup: ${before_gb} GB available"

    # Mise
    ~/.local/bin/mise implode --yes || true
    ~/.local/share/mise/bin/mise implode --yes || true

    # System
    rm -rf "/private/var/tmp/SpeechModelCache/" || true
    rm -rf ~/vendor/DerivedData || true
    rm -rf ~/.bundle || true
    rm -rf ~/.gem || true

    # Xcode
    rm -rf ~/Library/Developer/Xcode/{DerivedData,Archives,Logs} || true
    xcrun simctl delete all || true

    # Android
    rm -rf ~/.gradle/caches/ || true
    rm -rf ~/.android/build-cache/ || true
    rm -rf ~/.kotlin/daemon/ || true

    # 記錄清理後的磁碟空間
    local after_kb=$(df -P / | awk 'NR==2 {print $4}')
    local after_gb=$(echo "scale=2; $after_kb / 1000000" | bc)
    local freed_gb=$(echo "scale=2; $after_gb - $before_gb" | bc)
    
    log "✅ Cache cleanup completed"
    log "📦 After cleanup: ${after_gb} GB available"
    log "💾 Freed storage: ${freed_gb} GB"
}

function check_disk_space {
    local threshold_gb=30
    local available_kb=$(df -P / | awk 'NR==2 {print $4}')
    local available_gb=$(echo "scale=2; $available_kb / 1000000" | bc)

    if (( $(echo "$available_gb < $threshold_gb" | bc -l) )); then
        log "⚠️  Disk below threshold (${available_gb} GB < ${threshold_gb} GB), running cleanup..."
        cleanup_disk_space
    else
        log "☑️ Disk space sufficient (${available_gb} GB), skipping cleanup."
    fi
}

function check_debug_flag {
    if [[ "$RUNNER_DEBUG" == "1" ]]; then
        log "🪲 RUNNER_DEBUG is set, cleaning..."
        cleanup_disk_space
    else
        log "☑️ RUNNER_DEBUG not set, skipping cleanup."
    fi
}

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
