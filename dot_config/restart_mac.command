#!/bin/bash

function runCrontab {
	function setCrontab {
		echo "Setting cron job: restart_mac.command"
		chmod +x "$HOME/.config/restart_mac.command"
		# 每週六早上 5:00 執行一次
		(crontab -l 2>/dev/null; echo "0 5 * * 6 /bin/bash \$HOME/.config/restart_mac.command") | crontab -
	}
	function getCrontab {
		echo "Current cron jobs:"
		crontab -l
	}
	function deleteCrontab {
		echo "Deleting all cron jobs"
		crontab -r
	}
	deleteCrontab
	setCrontab
	getCrontab
}

function main {
	runCrontab
	~/.local/bin/mise run --cd="$HOME/.config/mise" config:dotfiles
	~/.local/bin/mise self-update --yes
	~/.local/bin/mise run --cd="$HOME/.config/mise" restart:macos
}

main
