#!/bin/bash

set -euxo pipefail

dnf5 -y remove xwaylandvideobridge
dnf5 -y install xdg-desktop-portal-gnome qt6ct
dnf5 -y install wev wlsunset cava playerctl
dnf5 -y --enable-repo=terra install mpvpaper

dnf5 -y copr enable avengemedia/dms
dnf5 -y install niri
dnf5 -y copr disable avengemedia/dms

dnf5 -y --enable-repo=terra install noctalia-shell
