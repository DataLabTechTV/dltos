#!/bin/bash

set -euxo pipefail

# shellcheck source=go-env.sh
. "$(dirname "${BASH_SOURCE[0]}")/go-env.sh"

# shellcheck source=uv-env.sh
. "$(dirname "${BASH_SOURCE[0]}")/uv-env.sh"

dnf5 -y install sqlite3
dnf5 -y install miller yq gnuplot

curl -L https://install.duckdb.org/v1.5.0/duckdb_cli-linux-amd64.zip | funzip >/usr/bin/duckdb
chmod +x /usr/bin/duckdb

go install github.com/IllumiKnowLabs/labstore/cmd/labstore@v0.1.0

uv tool install termgraph
uv tool install visidata
