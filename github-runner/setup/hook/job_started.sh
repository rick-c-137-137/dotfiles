#!/bin/sh

source ~/.zshrc
git config --global --unset credential.helper || true
git config --global --unset-all "http.https://github.com/.extraheader" || true


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
        checkDebugging
    else
        echo "No Check Disk Space"
    fi
}

monitorCache