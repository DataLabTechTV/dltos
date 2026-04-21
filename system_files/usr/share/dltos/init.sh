#!/usr/bin/env bash

set -euxo pipefail

DLTOS_DIR="$(dirname "${BASH_SOURCE[0]}")"

. $DLTOS_DIR/go-env.sh
. $DLTOS_DIR/cargo-env.sh
. $DLTOS_DIR/uv-env.sh

exists() {
	[ $# -ge 1 ] || return 1
	command -v $1 >/dev/null 2>&1
}

install_language_tools() {
	exists just-lsp || cargo install just-lsp
}

install_shell_tools() {
	exists witr || go install github.com/pranshuparmar/witr/cmd/witr@latest
}

install_network_tools() {
	exists mc || go install github.com/minio/mc@latest
	exists s5cmd || go install github.com/peak/s5cmd/v2@master
	exists warp || go install github.com/minio/warp@latest
	exists httpie || uv tool install --with=httpie-aws-authv4 httpie
}

install_graphics_tools() {
	exists rembg || uv tool install rembg[gpu,cli]
}

install_dev_tools() {
	alternatives --install /usr/bin/vim vim /usr/bin/nvim 100
	exists hugo || go install github.com/gohugoio/hugo@v0.111.3
}

install_container_tools() {
	exists podman || ln -s /usr/bin/distrobox-host-exec /usr/local/bin/podman
	exists buildah || ln -s /usr/bin/distrobox-host-exec /usr/local/bin/buildah
	exists skopeo || ln -s /usr/bin/distrobox-host-exec /usr/local/bin/skopeo
	exists lazydocker || go install github.com/jesseduffield/lazydocker@latest
	exists cosign || go install github.com/sigstore/cosign/v3/cmd/cosign@latest
}

install_ai_tools() {
	exists ramalama || ln -s /usr/bin/distrobox-host-exec /usr/local/bin/ramalama
}

install_data_tools() {
	exists duckdb || curl https://install.duckdb.org | sh
	exists labstore || go install github.com/IllumiKnowLabs/labstore/cmd/labstore@v0.1.0
	exists termgraph || uv tool install termgraph
	exists vd || uv tool install visidata
}

install_language_tools &&
	install_shell_tools &&
	install_network_tools &&
	install_graphics_tools &&
	install_dev_tools &&
	install_container_tools &&
	install_ai_tools &&
	install_data_tools
