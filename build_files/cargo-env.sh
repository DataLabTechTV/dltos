#!/usr/bin/env bash

export CARGO_HOME=/var/cache/cargo
export CARGO_TARGET_DIR=/var/cache/cargo-target
export CARGO_INSTALL_ROOT=/usr

if [ "$USE_ARTIFACT_KEEPER" = "true" ]; then
    export CARGO_REGISTRIES_ARTIFACT_KEEPER_INDEX=sparse+https://artifacts.lab.lan/cargo/cargo/index/
    export CARGO_REGISTRY_DEFAULT=artifact-keeper
fi
