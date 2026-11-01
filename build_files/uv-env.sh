#!/usr/bin/env bash

export UV_CACHE_DIR=/var/cache/uv
export UV_PYTHON_INSTALL_DIR=/usr/share/uv/python
export UV_TOOL_DIR=/usr/share/uv/tools
export UV_TOOL_BIN_DIR=/usr/bin
export UV_LINK_MODE=copy

if [ "$USE_ARTIFACT_KEEPER" = "true" ]; then
    echo "Enabling Artifact Keeper for Python"
    export PIP_INDEX_URL=https://artifacts.lab.lan/pypi/simple
fi
