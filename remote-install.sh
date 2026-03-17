#!/bin/bash

URL="https://github.com/tyleruploads/tycheck/releases/latest/download/tycheck.tar.gz"

echo "Downloading tycheck"

TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

curl -sSL "$URL" | tar -xz

if [ -f "install.sh" ]; then
	sudo bash install.sh
else
	echo "[Error] install.sh not found"
	exit 1
fi

cd ~
rm -rf "$TEMP_DIR"