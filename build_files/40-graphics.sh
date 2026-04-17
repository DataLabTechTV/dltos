#!/bin/bash

set -euxo pipefail

# shellcheck source=uv-env.sh
. "$(dirname "${BASH_SOURCE[0]}")/uv-env.sh"

dnf5 -y install ImageMagick-heic
dnf5 -y --enable-repo=rpmfusion-free install libheif-freeworld

uv tool install rembg[gpu,cli]
