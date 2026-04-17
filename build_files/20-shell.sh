#!/bin/bash

set -euxo pipefail

# shellcheck source=cargo-env.sh
. "$(dirname "${BASH_SOURCE[0]}")/cargo-env.sh"

# shellcheck source=go-env.sh
. "$(dirname "${BASH_SOURCE[0]}")/go-env.sh"

dnf5 -y install kitty

go install github.com/probeldev/niri-float-sticky@latest

dnf5 -y copr enable atim/starship
dnf5 -y install starship
dnf5 -y copr disable atim/starship

dnf5 -y install chezmoi direnv keychain
dnf5 -y install zoxide bat ripgrep fd-find
cargo install eza

dnf5 -y install ncdu age
go install github.com/pranshuparmar/witr/cmd/witr@latest
