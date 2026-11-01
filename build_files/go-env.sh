#!/usr/bin/env bash

export GOBIN=/usr/bin
export GOPATH=/var/cache/go
export GOCACHE=/var/cache/go-build

mkdir -p "$GOBIN" "$GOPATH" "$GOCACHE"

if [ "$USE_ARTIFACT_KEEPER" = "true" ]; then
    echo "Enabling Artifact Keeper for Go"
    export GOPROXY=https://artifacts.lab.lan/go/go,direct
    export GONOSUMCHECK='*'
fi
