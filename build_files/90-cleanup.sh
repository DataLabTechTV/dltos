#!/usr/bin/env bash

if [ "$USE_ARTIFACT_KEEPER" = "true" ]; then
    echo "Cleaning up Artifact Keeper RPM repos"

    # Re-enabled default repos and disable Artifact Keeper's
    dnf config-manager \
        --set-enabled fedora updates fedora-multimedia terra \
        --set-disabled \
            artifact-keeper-fedora artifact-keeper-fedora-updates \
            artifact-keeper-fedora-multimedia artifact-keeper-terra
fi

# Remove Artifact Keeper repos regardless
rm -f /etc/yum.repos.d/artifact-keeper.repo
