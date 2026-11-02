#!/usr/bin/env bash

set -euxo pipefail

dnf5 config-manager setopt zchunk=False
dnf5 config-manager setopt keepcache=1

if [ "$USE_ARTIFACT_KEEPER" = "true" ]; then
    echo "Using Artifact Keeper RPM repos"

    # Disable default RPM repos in favor of Artifact Keeper's

    install -m644 /ctx/artifact-keeper.repo /etc/yum.repos.d/

    dnf config-manager disable fedora updates fedora-multimedia terra
    dnf config-manager enable \
        artifact-keeper-fedora artifact-keeper-fedora-updates \
        artifact-keeper-fedora-updates-archive \
        artifact-keeper-fedora-multimedia artifact-keeper-terra
fi
