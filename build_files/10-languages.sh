#!/bin/bash

set -euxo pipefail

# shellcheck source=go-env.sh
. "$(dirname "${BASH_SOURCE[0]}")/go-env.sh"

# shellcheck source=cargo-env.sh
. "$(dirname "${BASH_SOURCE[0]}")/cargo-env.sh"

# --- Go ---
dnf5 -y install golang delve gopls golangci-lint

# --- Rust ---
dnf5 -y install cargo

# --- Python ---
dnf5 -y install uv python3-devel

# --- Node ---
dnf5 -y install nodejs-npm

# --- Shell ---
dnf5 -y install shfmt ShellCheck

# --- Justfile ---
cargo install just-lsp
