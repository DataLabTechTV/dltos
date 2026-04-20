#!/usr/bin/env bash

set -euxo pipefail

export SHELL=/usr/bin/fish

dnf5 -y install distribution-gpg-keys
rpm --import \
  /usr/share/distribution-gpg-keys/rpmfusion/RPM-GPG-KEY-rpmfusion-free-fedora-$(rpm -E %fedora) \
  /usr/share/distribution-gpg-keys/rpmfusion/RPM-GPG-KEY-rpmfusion-nonfree-fedora-$(rpm -E %fedora)
dnf5 -y --setopt=localpkg_gpgcheck=1 install \
  https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
  https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

rpm --import https://repos.fyralabs.com/terra$(rpm -E %fedora)/key.asc
dnf5 -y --repofrompath 'terra-repo,https://repos.fyralabs.com/terra$releasever' install terra-release
dnf5 -y makecache

dnf5 -y copr enable atim/starship
dnf5 -y copr enable dejan/lazygit
