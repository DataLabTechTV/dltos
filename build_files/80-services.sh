#!/usr/bin/env bash

set -euxo pipefail

systemctl --global enable niri-float.sticky.service
