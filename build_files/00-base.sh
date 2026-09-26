#!/usr/bin/env bash

set -euxo pipefail

dnf5 -y remove fw-fanctrl
dnf5 -y install zsh
dnf5 -y install kitty

dnf5 -y remove xwaylandvideobridge

# Temporary fix, until 0.8.3 is released
dnf5 -y install xwayland-satellite-0.8.1-1.fc44
dnf5 versionlock add xwayland-satellite

dnf5 -y install xdg-desktop-portal-gnome qt6ct
dnf5 -y install wev wlsunset cava playerctl pavucontrol
dnf5 -y --enable-repo=terra install mpvpaper nwg-look

dnf5 -y copr enable yalter/niri
dnf5 -y install niri
dnf5 -y copr disable yalter/niri

dnf5 -y install noctalia
