#!/bin/sh

sh ~/github-runner/setup/cleanup_runner_cache.sh disk_space

cleanup_old_dirs() {
	TARGET_DIR="$HOME/vendor/DerivedData/viaBranch"
	# 檢查目錄是否存在
	if [ -d "$TARGET_DIR" ]; then
	  find "$TARGET_DIR" -mindepth 1 -maxdepth 1 -type d -mtime +7 -exec rm -rf {} +
	  echo "✅ Old subdirectories (modified > 7 days ago) have been removed."
	else
	  echo "⚠️ Directory $TARGET_DIR does not exist."
	fi
}

cleanup_old_dirs
