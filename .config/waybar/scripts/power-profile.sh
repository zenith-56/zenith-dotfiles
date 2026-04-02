#!/usr/bin/env bash

PROFILE=$(/home/maximocruz/zenith-dotfiles/.local/bin/zenith-power-profile get)

case "$PROFILE" in
	balanced) echo "" ;;
	power-saver) echo "󱈑" ;;
	performance) echo "" ;;
	*) echo "󱇑" ;;
esac
