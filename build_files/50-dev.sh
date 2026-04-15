#!/bin/bash

set -euxo pipefail

# shellcheck source=go-env.sh
source "$(dirname "${BASH_SOURCE[0]}")/go-env.sh"

dnf5 -y swap vim-enhanced neovim
alternatives --install /usr/bin/vim vim /usr/bin/nvim 100

dnf5 -y install pre-commit cloc git-delta

dnf5 -y copr enable dejan/lazygit
dnf5 -y install lazygit
dnf5 -y copr disable dejan/lazygit

go install github.com/gohugoio/hugo@v0.111.3

dnf5 -y --enable-repo=terra install zed
