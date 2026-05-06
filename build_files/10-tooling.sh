#!/usr/bin/env bash

set -euxo pipefail

ENV_DIR="$(dirname "${BASH_SOURCE[0]}")"

# shellcheck source=uv-env.sh
. "$ENV_DIR/uv-env.sh"

dnf5 -y install uv firecracker

uv tool install ramalama
