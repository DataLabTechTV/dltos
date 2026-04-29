#!/usr/bin/env bash

set -euxo pipefail

# Copy of system_files/usr/share/dltos
DLTOS_DIR="$(dirname "${BASH_SOURCE[0]}")/dltos"

. $DLTOS_DIR/uv-env.sh

dnf5 -y install uv netavark

uv tool install ramalama
