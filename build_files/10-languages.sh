#!/bin/bash

set -euxo pipefail

# shellcheck source=go-env.sh
source "$(dirname "${BASH_SOURCE[0]}")/go-env.sh"

# shellcheck source=cargo-env.sh
source "$(dirname "${BASH_SOURCE[0]}")/cargo-env.sh"

dnf5 -y install golang cargo uv nodejs-npm
dnf5 -y install golangci-lint delve
dnf5 -y install python3-devel

go install golang.org/x/tools/gopls@latest
go install mvdan.cc/sh/v3/cmd/shfmt@latest

cargo install just-lsp
