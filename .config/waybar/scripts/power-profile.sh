#!/usr/bin/env bash

PROFILE=$("$HOME/.local/bin/zenith-power-profile" get 2>/dev/null)

case "$PROFILE" in
	balanced) echo "" ;;
	power-saver) echo "󱈑" ;;
	performance) echo "" ;;
	*) echo "󱇑" ;;
esac
