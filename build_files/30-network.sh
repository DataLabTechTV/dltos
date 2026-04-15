#!/bin/bash

set -euxo pipefail

# shellcheck source=go-env.sh
source "$(dirname "${BASH_SOURCE[0]}")/go-env.sh"

# shellcheck source=uv-env.sh
source "$(dirname "${BASH_SOURCE[0]}")/uv-env.sh"

dnf5 -y install iperf3
dnf5 -y install mkcert
dnf5 -y install nc nmap prettyping

dnf5 -y install rclone
go install github.com/minio/mc@latest
go install github.com/peak/s5cmd/v2@master

go install github.com/minio/warp@latest

uv tool install --with=httpie-aws-authv4 httpie
