#!/usr/bin/env bash

export CARGO_HOME=/var/cache/cargo
export CARGO_TARGET_DIR=/var/cache/cargo-target
export CARGO_INSTALL_ROOT=/usr

if [ "$USE_ARTIFACT_KEEPER" = "true" ]; then
    # echo "Enabling Artifact Keeper for Cargo"
    # install -Dm644 /ctx/cargo.config.toml "$CARGO_HOME/config.toml"
    true
fi
