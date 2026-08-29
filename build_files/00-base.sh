#!/usr/bin/env bash

set -euxo pipefail

dnf5 -y remove fw-fanctrl
dnf5 -y install zsh
dnf5 -y install kitty

dnf5 -y remove xwaylandvideobridge
dnf5 -y install xdg-desktop-portal-gnome qt6ct
dnf5 -y install wev wlsunset cava playerctl pavucontrol
dnf5 -y --enable-repo=terra install mpvpaper nwg-look

dnf5 -y copr enable yalter/niri
dnf5 -y install niri
dnf5 -y copr disable yalter/niri

dnf5 -y --enable-repo=terra install noctalia-legacy
