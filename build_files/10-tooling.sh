#!/usr/bin/env bash

set -euxo pipefail

ENV_DIR="$(dirname "${BASH_SOURCE[0]}")"

# shellcheck source=/dev/null
. "$ENV_DIR/go-env.sh"

# shellcheck source=/dev/null
. "$ENV_DIR/cargo-env.sh"

# shellcheck source=/dev/null
. "$ENV_DIR/uv-env.sh"

setup_rpmfusion() {
    rpm --import \
        "/usr/share/distribution-gpg-keys/rpmfusion/RPM-GPG-KEY-rpmfusion-free-fedora-$(rpm -E %fedora)" \
        "/usr/share/distribution-gpg-keys/rpmfusion/RPM-GPG-KEY-rpmfusion-nonfree-fedora-$(rpm -E %fedora)"

    dnf5 -y --setopt=localpkg_gpgcheck=1 install \
        "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
        "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"

    dnf5 config-manager disable 'rpmfusion-*'
}

install_language_tools() {
    dnf5 -y install cmake golang delve gopls golangci-lint cargo uv python3-devel nodejs-npm shfmt ShellCheck
    cargo install just-lsp
}

install_fonts() {
    dnf5 -y --enable-repo=terra install cascadiacode-nerd-fonts cascadiamono-nerd-fonts
}

install_shell_tools() {
    dnf5 -y copr enable atim/starship
    dnf5 -y install starship
    dnf5 -y copr disable atim/starship

    dnf5 -y install chezmoi direnv keychain zoxide bat ripgrep fd-find eza ncdu age btop nvtop tldr
    go install github.com/pranshuparmar/witr/cmd/witr@latest
}

install_network_tools() {
    dnf5 -y install iperf3 mkcert nc nmap ipcalc prettyping rclone
    go install github.com/minio/mc@latest
    go install github.com/peak/s5cmd/v2@master
    go install github.com/minio/warp@latest
    uv tool install --with=httpie-aws-authv4 httpie
}

install_graphics_tools() {
    dnf5 -y install ImageMagick ImageMagick-heic libheif libde265 chafa
    uv tool install rembg[gpu,cli]
}

install_doc_tools() {
    dnf5 -y install pandoc
}

install_dev_tools() {
    dnf5 -y copr enable dejan/lazygit
    dnf5 -y install lazygit
    dnf5 -y copr disable dejan/lazygit

    dnf5 -y swap vim-enhanced neovim
    alternatives --install /usr/bin/vim vim /usr/bin/nvim 100

    dnf5 -y --enable-repo=terra install zed
    dnf5 -y install emacs-pgtk
    dnf5 -y install pre-commit cloc git-delta
    go install github.com/gohugoio/hugo@v0.111.3
}

install_container_tools() {
    dnf5 -y install docker-cli docker-compose-switch
    mv /usr/bin/docker /usr/bin/docker.real
    mv /usr/bin/docker-compose /usr/bin/docker-compose.real

    dnf5 -y install firecracker
    go install github.com/jesseduffield/lazydocker@latest
    go install github.com/sigstore/cosign/v3/cmd/cosign@latest
}

install_ai_tools() {
    uv tool install ramalama

    clampdown_url=https://github.com/89luca89/clampdown/releases/download/v0.1/clampdown-linux-amd64
    clampdown_bin=/usr/bin/clampdown
    curl -fL $clampdown_url -o $clampdown_bin && chmod +x $clampdown_bin
}

install_data_tools() {
    dnf5 -y install jq yq sqlite3 miller gnuplot
    uv tool install termgraph
    uv tool install visidata
    go install github.com/IllumiKnowLabs/labstore/cmd/labstore@v0.1.0

    curl -L https://install.duckdb.org/v1.5.0/duckdb_cli-linux-amd64.zip | funzip >/usr/bin/duckdb
    chmod +x /usr/bin/duckdb
}

setup_rpmfusion
install_language_tools
install_fonts
install_shell_tools
install_network_tools
install_graphics_tools
install_doc_tools
install_dev_tools
install_container_tools
install_ai_tools
install_data_tools
