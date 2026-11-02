#!/usr/bin/env bash

set -euxo pipefail

SCRIPT_DIR="$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)"

# shellcheck source=/dev/null
. "$SCRIPT_DIR/cargo-env.sh"

if [ "$USE_ARTIFACT_KEEPER" = "true" ]; then
    echo "Cleaning up Artifact Keeper RPM repos"

    # Re-enable default RPM repos and disable and remove Artifact Keeper's

    dnf config-manager enable fedora updates fedora-multimedia terra
    dnf config-manager disable \
        artifact-keeper-fedora artifact-keeper-fedora-updates \
        artifact-keeper-fedora-multimedia artifact-keeper-terra

    rm -f /etc/yum.repos.d/artifact-keeper.repo
    rm -f "$CARGO_HOME/config.toml"
fi

dnf5 config-manager unsetopt keepcache
