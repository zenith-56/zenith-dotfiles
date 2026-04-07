#!/usr/bin/env bash
# =============================================================================
# Rofi Docker & VMs Menu
# =============================================================================
# Description : Submenu for Docker management and VM operations.
# =============================================================================

set -euo pipefail

source "$(dirname "$0")/common.sh"

main_menu() {
    printf ' 󰡨  Docker\n 󰢹  VMs Management\n'
}

docker_menu() {
    printf '   Lazydocker\n 󱖫  Docker Status\n 󰌍  Back\n'
}

vms_menu() {
    printf '   Launch VM\n   Stop VM\n   Install VM\n   Remove VM\n   VM Status\n 󰌍  Back\n'
}

show_main() {
    while true; do
        chosen=$(main_menu | rofi_run "theme.rasi" -placeholder "Select Category...") || exit 0

        case "$chosen" in
            *Docker) show_docker ;;
            *VMs\ Management) show_vms ;;
            "") exit 0 ;;
        esac
    done
}

show_docker() {
    while true; do
        chosen=$(docker_menu | rofi_run "theme.rasi" -placeholder "Docker...") || break

        case "$chosen" in
            *Lazydocker)
                kitty --class "zenith-docker" --title "Lazydocker" -e bash -c "zenith docker lazy" &
                exit 0
                ;;
            *Docker\ Status)
                kitty --class "zenith-docker" --title "Docker Status" -e bash -c "zenith docker status; read -rp 'Press ENTER to close...'" &
                exit 0
                ;;
            *Back) return 0 ;;
            "") exit 0 ;;
        esac
    done
}

show_vms() {
    while true; do
        chosen=$(vms_menu | rofi_run "theme.rasi" -placeholder "VMs Management...") || break

        case "$chosen" in
            *Launch\ VM)
                kitty --class "zenith-vm" --title "Launch VM" -e bash -c "zenith vm launch" &
                exit 0
                ;;
            *Stop\ VM)
                kitty --class "zenith-vm" --title "Stop VM" -e bash -c "zenith vm stop" &
                exit 0
                ;;
            *Install\ VM)
                kitty --class "zenith-vm" --title "Install VM" -e bash -c "zenith vm install" &
                exit 0
                ;;
            *Remove\ VM)
                kitty --class "zenith-vm" --title "Remove VM" -e bash -c "zenith vm remove" &
                exit 0
                ;;
            *VM\ Status)
                kitty --class "zenith-vm" --title "VM Status" -e bash -c "zenith vm list; read -rp 'Press ENTER to close...'" &
                exit 0
                ;;
            *Back) return 0 ;;
            "") exit 0 ;;
        esac
    done
}

show_main
