#!/bin/sh

function monitorCache {
    function freeDiskSpace {
        # Android
        # rm -rf "$HOME/.gradle/caches" || true
        # iOS
        rm -rf "$HOME/vendor/DerivedData" || true
        rm -rf "$HOME/Library/Developer/Xcode/Archives" || true
        rm -rf "/private/var/tmp/SpeechModelCache/"
        xcrun simctl delete all || true
        echo "Did free disk space."
    }

    # 定義函數，用於檢查根目錄的磁碟空間是否小於指定閾值
    function checkDiskSpace {
        # 使用 df 命令獲取根目錄的空間信息，並提取可用空間的數值
        available_space_kb=$(df -P / | awk 'NR==2 {print $4}')

        # 計算可用空間（單位：GB）
        available_space_gb=$(echo "scale=2; $available_space_kb / 1000000" | bc)

        # 設置閾值（單位：GB）
        threshold_gb=40

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