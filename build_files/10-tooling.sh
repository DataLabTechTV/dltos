#!/usr/bin/env bash

set -euxo pipefail

# Copy of system_files/usr/share/dltos
DLTOS_DIR="$(dirname "${BASH_SOURCE[0]}")/dltos"

# shellcheck disable=SC1091
. "$DLTOS_DIR/uv-env.sh"

dnf5 -y install uv firecracker

curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix |
	sh -s -- install linux --no-start-daemon --no-confirm

uv tool install ramalama
