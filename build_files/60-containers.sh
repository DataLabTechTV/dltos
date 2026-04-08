#!/bin/bash

set -euxo pipefail

# shellcheck source=go-env.sh
source "$(dirname "${BASH_SOURCE[0]}")/go-env.sh"

dnf5 -y install docker-cli docker-compose-switch
mv /usr/bin/docker /usr/bin/docker.real
mv /usr/bin/docker-compose /usr/bin/docker-compose.real

go install github.com/jesseduffield/lazydocker@latest
go install github.com/sigstore/cosign/v3/cmd/cosign@latest
