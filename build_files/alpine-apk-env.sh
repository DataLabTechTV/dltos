#!/usr/bin/env bash

if [ "$USE_ARTIFACT_KEEPER" = "true" ]; then
    echo "Enabling Artifact Keeper for Alpine APKs"
    cp /ctx/alpine-apk-repositories /etc/apk/repositories
fi
