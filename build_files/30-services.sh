#!/usr/bin/env bash

set -euxo pipefail

semanage fcontext -a -t bin_t /usr/bin/bat
restorecon -v /usr/bin/bat
systemctl --global enable bat-cache-build.service

systemctl --global enable niri-float-sticky.service
