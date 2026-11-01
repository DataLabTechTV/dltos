#!/usr/bin/env bash

set -euxo pipefail

dnf5 clean all
dnf5 makecache --refresh

dnf5 config-manager setopt keepcache=1

if [ "$USE_ARTIFACT_KEEPER" = "true" ]; then
    echo "Using Artifact Keeper RPM repos"

    # Disable default RPM repos in favor of Artifact Keeper's

    install -m644 /ctx/artifact-keeper.repo /etc/yum.repos.d/

    dnf config-manager disable fedora updates fedora-multimedia terra
    dnf config-manager enable \
        artifact-keeper-fedora artifact-keeper-fedora-updates \
        artifact-keeper-fedora-multimedia artifact-keeper-terra

    # Enable Artifact Keeper repos for language packages

    PIP_INDEX_URL=https://artifacts.lab.lan/pypi/simple
    GOPROXY=https://artifacts.lab.lan/go/go,direct
    GONOSUMCHECK='*'
    CARGO_REGISTRIES_ARTIFACT_KEEPER_INDEX=sparse+https://artifacts.lab.lan/cargo/cargo/index/
    CARGO_REGISTRY_DEFAULT=artifact-keeper

    export PIP_INDEX_URL GOPROXY GONOSUMCHECK CARGO_REGISTRIES_ARTIFACT_KEEPER_INDEX CARGO_REGISTRY_DEFAULT
fi
