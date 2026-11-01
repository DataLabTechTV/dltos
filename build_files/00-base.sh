#!/usr/bin/env bash
set -euxo pipefail

if [ "$USE_ARTIFACT_KEEPER" = "true" ]; then
    echo "Using Artifact Keeper RPM repos"

    # Disable default repos in favor of Artifact Keeper's
    dnf config-manager \
        --set-disabled fedora updates fedora-multimedia terra \
        --set-enabled \
            artifact-keeper-fedora artifact-keeper-fedora-updates \
            artifact-keeper-fedora-multimedia artifact-keeper-terra
fi

dnf5 -y remove fw-fanctrl
dnf5 -y install zsh
dnf5 -y install kitty

dnf5 -y remove xwaylandvideobridge msedit

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
