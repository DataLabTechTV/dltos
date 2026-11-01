#!/usr/bin/env bash

set -euxo pipefail

mv /etc/profile.d/bazzite-neofetch.sh /etc/profile.d/dltos-neofetch.sh
sed -i "s|/usr/share/ublue-os/bazzite/fastfetch.jsonc|/usr/share/dltos/fastfetch.jsonc|g" \
    /etc/profile.d/dltos-neofetch.sh
