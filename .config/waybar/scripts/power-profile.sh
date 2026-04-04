#!/usr/bin/env bash
set -euo pipefail

PROFILE=$("$HOME/.local/bin/zenith" power profile get 2>/dev/null || true)

case "$PROFILE" in
	balanced) echo "" ;;
	power-saver) echo "󱈑" ;;
	performance) echo "" ;;
	*) echo "󱇑" ;;
esac
