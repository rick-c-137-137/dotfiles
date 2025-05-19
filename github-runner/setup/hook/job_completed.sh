#!/bin/sh

function monitorCache {
    function freeDiskSpace {
        echo "Cleaning..."
        rm -rf "/private/var/tmp/SpeechModelCache/"

        echo "🔧 Cleaning Xcode caches..."
        rm -rf "$HOME/vendor/DerivedData" || true
        rm -rf ~/Library/Developer/Xcode/DerivedData/
        rm -rf ~/Library/Developer/Xcode/Archives/
        rm -rf ~/Library/Developer/Xcode/Logs/
        xcrun simctl delete all || true
        # rm -rf ~/Library/Developer/Xcode/iOS\ DeviceSupport/*
        # rm -rf ~/Library/Developer/CoreSimulator/Devices/*
        # rm -rf ~/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/*

        echo "📱 Cleaning Android caches..."
        rm -rf ~/.gradle/caches/
        rm -rf ~/.android/build-cache/
        rm -rf ~/.kotlin/daemon/
        # rm -rf ~/Library/Caches/Google/AndroidStudio*

        echo "Did free disk space."
    }

    # 定義函數，用於檢查根目錄的磁碟空間是否小於指定閾值
    function checkDiskSpace {
        # 使用 df 命令獲取根目錄的空間信息，並提取可用空間的數值
        available_space_kb=$(df -P / | awk 'NR==2 {print $4}')

        # 計算可用空間（單位：GB）
        available_space_gb=$(echo "scale=2; $available_space_kb / 1000000" | bc)

        # 設置閾值（單位：GB
        threshold_gb=30

        # 比較可用空間是否小於閾值
        echo "Checking: Available storage $available_space_gb GB. clean if < $threshold_gb GB"
        if (( $(echo "$available_space_gb < $threshold_gb" | bc -l) )); then
            freeDiskSpace
        else
            echo "No free disk space"
        fi
    }

    function checkDebugging {
        echo "Checking: Delete cache if var RUNNER_DEBUG exists: $RUNNER_DEBUG"
        if [[ $RUNNER_DEBUG == "1" ]]; then
            freeDiskSpace
        else
            echo "No free disk space"
        fi
    }

    # 定義一個函數來檢查數組是否包含某個元素
    function contains() {
      local element
      for element in "${@:2}"; do
        if [[ "$element" == "$1" ]]; then
          return 0
        fi
      done
      return 1
    }

    # Those runner have label `app`
    work_runner_names=($PINKOI_RUNNER_NAMES)
    
    # 呼叫函數
    if contains "$RUNNER_NAME" "${work_runner_names[@]}"; then
        checkDiskSpace
        checkDebugging
    else
        echo "No Check Disk Space"
    fi
}

monitorCache