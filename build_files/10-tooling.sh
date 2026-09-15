#!/usr/bin/env bash

set -euxo pipefail

ENV_DIR="$(dirname "${BASH_SOURCE[0]}")"

# shellcheck source=/dev/null
. "$ENV_DIR/go-env.sh"

# shellcheck source=/dev/null
. "$ENV_DIR/cargo-env.sh"

# shellcheck source=/dev/null
. "$ENV_DIR/uv-env.sh"

install_language_tools() {
    dnf5 -y install cmake golang delve gopls golangci-lint cargo uv \
        python3-devel python3-pytest nodejs-npm tidy shfmt ShellCheck
    cargo install just-lsp
}

install_fonts() {
    dnf5 -y --enable-repo=terra install fantasquesansmono-nerd-fonts
}

install_shell_tools() {
    url='https://github.com/michel-kraemer/zsh-patina/releases/download/1.8.0/zsh-patina-v1.8.0-x86_64-unknown-linux-gnu.tar.gz'
    tmpdir="$(mktemp -d)"
    curl -L "$url" -o - | tar xvzf - -C "$tmpdir" --strip-components=1
    cp "$tmpdir/zsh-patina" /usr/bin
    cp "$tmpdir/completion/_zsh-patina" /usr/share/zsh/site-functions
    rm -rf "$tmpdir"

    dnf5 -y copr enable atim/starship
    dnf5 -y install starship
    dnf5 -y copr disable atim/starship

    dnf5 -y install chezmoi direnv keychain zoxide bat ripgrep fd-find eza \
        ncdu age strace btop nvtop trash-cli perl-Image-ExifTool
    dnf5 -y --enable-repo=terra install yazi
    go install github.com/pranshuparmar/witr/cmd/witr@latest
}

install_network_tools() {
    dnf5 -y install iperf3 mkcert nc nmap ipcalc prettyping rclone
    go install github.com/peak/s5cmd/v2@master
    uv tool install --with=httpie-aws-authv4 httpie
}

install_mail_tools() {
    dnf5 -y install isync maildir-utils
}

install_graphics_tools() {
    dnf5 -y install ImageMagick ImageMagick-heic libheif libde265 chafa
    uv python install 3.13.12
    uv tool install --python 3.13.12 rembg[gpu,cli]
}

install_doc_tools() {
    dnf5 -y install pandoc texlive-scheme-basic texlive-collection-latexextra \
        texlive-collection-fontsrecommended texlive-collection-langportuguese \
        texlive-dvipng
}

install_container_tools() {
    dnf5 -y install docker-cli docker-compose-switch oci-seccomp-bpf-hook cosign
    mv /usr/bin/docker /usr/bin/docker.real
    mv /usr/bin/docker-compose /usr/bin/docker-compose.real

    go install github.com/jesseduffield/lazydocker@latest
}

install_dev_tools() {
    dnf5 -y copr enable dejan/lazygit
    dnf5 -y install lazygit
    dnf5 -y copr disable dejan/lazygit

    dnf5 -y swap vim-enhanced neovim
    alternatives --install /usr/bin/vim vim /usr/bin/nvim 100

    dnf5 -y install emacs-pgtk libvterm-devel libtool
    dnf5 -y install pre-commit cloc git-delta git-filter-repo ansible opentofu

    go install github.com/gohugoio/hugo@v0.111.3
}

install_ai_tools() {
    uv tool install ramalama
}

install_data_tools() {
    dnf5 -y install jq yq sqlite3 postgresql miller gnuplot parallel xxd xmlstarlet
    uv tool install termgraph
    uv tool install visidata
    uv tool install csvkit
    go install github.com/IllumiKnowLabs/labstore/cmd/labstore@v0.1.0

    curl -L https://install.duckdb.org/v1.5.5/duckdb_cli-linux-amd64.zip | funzip >/usr/bin/duckdb
    chmod +x /usr/bin/duckdb
}

install_backup_tools() {
    dnf5 -y install borgbackup
}

install_language_tools
install_fonts
install_shell_tools
install_network_tools
install_mail_tools
install_graphics_tools
install_doc_tools
install_container_tools
install_dev_tools
install_ai_tools
install_data_tools
install_backup_tools
