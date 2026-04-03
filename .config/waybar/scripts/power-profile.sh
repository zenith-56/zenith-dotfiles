#!/usr/bin/env bash

PROFILE=$(zenith power profile get)

case "$PROFILE" in
	balanced) echo "" ;;
	power-saver) echo "󱈑" ;;
	performance) echo "" ;;
	*) echo "󱇑" ;;
esac
