#!/usr/bin/env bash

set -euxo pipefail

rpm --import https://repos.fyralabs.com/terra$(rpm -E %fedora)/key.asc
dnf5 -y --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' install terra-release
dnf5 -y makecache

dnf5 -y remove xwaylandvideobridge
dnf5 -y install kitty
dnf5 -y install xdg-desktop-portal-gnome qt6ct
dnf5 -y install wev wlsunset cava playerctl
dnf5 -y install mpvpaper

dnf5 -y copr enable avengemedia/dms
dnf5 -y install niri
dnf5 -y copr disable avengemedia/dms

dnf5 -y install noctalia-shell

dnf5 config-manager setopt terra.enabled=false
