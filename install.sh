#!/bin/bash -u

# Configuration
APP_NAME="tycheck"
BIN_DEST="/usr/local/bin/$APP_NAME"
DESKTOP_DEST="/usr/share/applications/$APP_NAME.desktop"

# Get dir of where installer is and cd to it
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check for root access
if [ "$EUID" -ne 0 ]; then
	echo "[Error] Please give root privledges to tycheck installer."
	exit 1
fi

# Check if zenity installed
if ! command -v zenity >/dev/null 2>&1; then
	echo "[Error] Missing dependancy: Zenity. Please install with 'sudo apt install zenity'."
	exit 1
fi

# Check if smartctl installed
if ! command -v smartctl >/dev/null 2>&1; then
	echo "[Warning] Missing dependancy: smartmontools (smartctl). Some health checks may be skipped."
fi

if ! command -v apt >/dev/null 2>&1; then
	echo "[Error] This script is designed for Debian based systems due to the heavy usage of apt in the script."
	exit 1
fi

install_app() {
	echo "--- INSTALLING $APP_NAME  ---"

	# Install script
	if [ -f "$DIR/tycheck" ]; then
		cp "$DIR/tycheck" "$BIN_DEST"
		chmod +x "$BIN_DEST"
		echo "[OK] Script installed to $BIN_DEST"
	else
		echo "[ERROR] tycheck bash file not in $DIR"
		exit 1
	fi

	# Install desktop file
	if [ -f "$DIR/tycheck.desktop" ]; then
		cp "$DIR/tycheck.desktop" "$DESKTOP_DEST"
		chmod 644 "$DESKTOP_DEST"
		echo "[OK] Desktop entry point installed to $DESKTOP_DEST"
	else
		echo "[ERROR] tycheck.desktop file not in $DIR"
		exit 1
	fi

	update-desktop-database /usr/share/applications
	echo "-- Success! --"
}

uninstall_app() {
	echo "--- Uninstalling $APP_NAME ---"
	rm -v -f "$BIN_DEST"
	rm -v -f "$DESKTOP_DEST"
	update-desktop-database /usr/share/applications
	echo "Uninstalled successfully"
}

# Handle arguements
case "$1" in
	-u|--uninstall)
		uninstall_app
		;;
	*)
		install_app
		;;
esac