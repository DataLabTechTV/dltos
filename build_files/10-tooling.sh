#!/usr/bin/env bash

DLTOS_DIR="$(readlink -f $(dirname "${BASH_SOURCE[0]}")/../system_files/usr/share/dltos)"

. $DLTOS_DIR/uv-env.sh

uv tool install ramalama
