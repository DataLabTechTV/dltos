#!/usr/bin/env bash

if [ "$USE_ARTIFACT_KEEPER" = "true" ]; then
    echo "Cleaning up Artifact Keeper RPM repos"

    # Re-enabled default RPM repos and disable Artifact Keeper's
    dnf config-manager enable fedora updates fedora-multimedia terra
    dnf config-manager disable \
        artifact-keeper-fedora artifact-keeper-fedora-updates \
        artifact-keeper-fedora-multimedia artifact-keeper-terra

    # Disable Artifact Keeper repos for language packages
    unset PIP_INDEX_URL GOPROXY GONOSUMCHECK CARGO_REGISTRIES_ARTIFACT_KEEPER_INDEX CARGO_REGISTRY_DEFAULT
fi

# Remove Artifact Keeper repos regardless
rm -f /etc/yum.repos.d/artifact-keeper.repo
