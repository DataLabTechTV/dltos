#!/usr/bin/env bash

set -euxo pipefail

systemctl enable bat-cache-build.service
systemctl --global enable niri-float-sticky.service
