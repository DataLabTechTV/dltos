#!/usr/bin/env bash

if [ "$USE_ARTIFACT_KEEPER" = "true" ]; then
    echo "Using Artifact Keeper RPM repos"

    # Disable default RPM repos in favor of Artifact Keeper's
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
