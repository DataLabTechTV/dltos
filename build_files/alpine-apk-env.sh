#!/usr/bin/env bash

if [ "$USE_ARTIFACT_KEEPER" = "true" ]; then
    cp /ctx/alpine-apk-repositories /etc/apk/repositories
fi
