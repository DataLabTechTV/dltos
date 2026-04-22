[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/dltos)](https://artifacthub.io/packages/search?repo=dltos)
[![Build DLT OS](https://github.com/DataLabTechTV/dltos/actions/workflows/build.yml/badge.svg)](https://github.com/DataLabTechTV/dltos/actions/workflows/build.yml)

<picture>
  <img alt="Shows the dltos logo, with three diagonal stripes in dark blue, cyan, and yellow. In the center, the acronym DLT is displayed in pink." src="https://raw.githubusercontent.com/DataLabTechTV/dltos/refs/heads/main/repo_files/dltos-logo.png" width="150px">
</picture>

# DLT OS

Custom Bazzite image based on [bazzite-nvidia-open](https://github.com/ublue-os/bazzite/pkgs/container/bazzite-nvidia-open). It adds a preconfigured [niri](https://niri-wm.github.io/niri/) + [noctalia](https://noctalia.dev/) minimal setup, providing a default system-wide config, as well as any tools or scripts required to solve any annoying or issues we might find. For example, we include a system-wide `tray-launch` script to wrap misbehaving `spawn-at-startup` entries that fail to properly load the tray icon.

DLT in `dltos` stands for Data Lab Tech, so `dltos` also provides all the software used for development, infra, and data-related tasks, as seen on the YouTube videos by [@DataLabTechTV](https://www.youtube.com/@DataLabTechTV).

I mostly maintain this image for myself and any viewers who want the same experience of what they see on my videos out-of-the-box. Regardless, if you have any requests, please let me know through the Discussion section.

For more details on how to build your own custom image, please read the [documentation](https://github.com/ublue-os/image-template/blob/main/README.md) provided with the Universal Blue template, which also applies to this image.

## Maintenance

### Switching

In order to switch to `dltos` from `bazzite-nvidia-open`, you can simply run the following command:

```bash
sudo bootc switch ghcr.io/datalabtechtv/dltos:latest
```

> [!CAUTION]
> Make sure your system has an NVIDIA GPU, otherwise the image is unlikely to work, due to it being based on `bazzite-nvidia-open`.

After you reboot, you'll be running `dltos`, with the default KDE and niri as an additional option. You can switch to niri as the default directly from the SDDM login manager shown on boot.

### Upgrading

When you need to update your system, you can either do it with `ujust update` or `rpm-ostree upgrade`, as usual, or can simply run:

```bash
sudo bootc upgrade
```

### Bundled Distrobox

In order to use the bundled `dltos` distrobox, the recommend approach is to just point your terminal do `/usr/bin/dltsh`, or simply `dltsh`, as it's already in the `PATH`. This script will create the distrobox for you on the first run and it will open it always by default in the future. You'll also be able to fallback to the host `bash`, if anything goes wrong.

So, for example for kitty, just edit `~/.config/kitty/kitty.conf` and set:

```
shell /usr/bin/dltsh
```

You can also checkout [DataLabTechTV/dotfiles](https://github.com/DataLabTechTV/dotfiles/blob/main/dot_config/kitty/kitty.conf) for a working example.

## Features

- Preconfigured niri out-of-the-box, with the noctalia shell, on the custom bootc image.
- Go, Rust, Python, and Node tooling, providing `go`, `cargo`, `uv`,  and`npm`, through a bundled distrobox config.
- System-wide tools, installed via `dnf5`, `go install`, `cargo install`, or `uv tool install`, making it easy to naturally extend, if you need to add to the bundled distrobox config, while keeping your home clean.

The following sections summarize the packages that DLT OS provides out-of-the-box, where [Base](#base) refers to the custom bootc image, while everything else is shipped as a distrobox config under `/etc/distrobox/dltos.ini`, which you can use by running the following commands:

```bash
distrobox assemble create --file /etc/distrobox/dltos.ini
distrobox enter dltos
```

### Base

For the base system, defined in the custom bootc image, we add `niri` and `noctalia-shell`, alongside a few utilities. We also remove `xwaylandvideobridge`, which opens a blank window by default on niri, but seems to be deprecated anyway. This let's us run the `xwayland-satellite` integration without issues.

| Package                    | Version  | Via    | Observation                                                                 |
| -------------------------- | -------- | ------ | --------------------------------------------------------------------------- |
| `niri` | >= 25.11 | `dnf5` | niri compositor |
| `noctalia-shell` | >= 4.7.6 | `dnf5` | Noctalia shell (bar and panels). |
| `niri-float-sticky` | >= 0.0.8 | `go` | Utility to keep a window visible on all workspaces. |
| `xdg-desktop-portal-gnome` | >=49.0   | `dnf5` | Required for the *Screen Capture (PipeWire)* feature on OBS.                |
| `qt6ct`                    | >=0.11   | `dnf5` | Let's you pick the Qt theme without using KDE utilities.                    |
| `wev`                      | >=1.1.0  | `dnf5` | Keyboard and mouse event debugging utility.                                 |
| `wlsunset`                 | >=0.4.0  | `dnf5` | Used for Noctalia's Night Light feature.                                    |
| `cava`                     | >=0.10.2 | `dnf5` | Used for Noctalia's audio visualizers.                                      |
| `playerctl`                | >=2.4.1  | `dnf5` | Controls your media player (e.g., Spotify) via preconfigured niri keybinds. |

#### Portals

Here are a few notes about portals. The system will install portal configs by default under `/usr/share/xdg-desktop-portal`. In DLT OS you'll find `niri-portals.conf` and `kde-portals.conf`, preinstalled by KDE and niri, respectively. By default, `niri-portals.conf` should be used. However, we currently still use `kwallet6`, and we haven't added `gnome-keyring` yet, so, for now, we suggest you create a custom config under `~/.config/xdg-desktop-portal/portals.conf` with the following configs:

```toml
[preferred]
default=gnome
org.freedesktop.impl.portal.FileChooser=kde
org.freedesktop.impl.portal.ScreenCast=gnome
org.freedesktop.impl.portal.Screenshot=gnome
```

 Please also notice that the `xdg-desktop-portal-gnome` package has been bugged since 2022. When adding multiple capture sources, or re-selecting the window for the source, it will not respond correctly. Follow their [#40](https://gitlab.gnome.org/GNOME/xdg-desktop-portal-gnome/-/issues/40) issue about this problem.

#### Qt Theming

We use `qt6ct` for theming Qt apps on niri. This is optional, but if you want to use it, the best approach is to create an environment config under `~/.config/environment.d/niri.conf` containing:

```bash
QT_QPA_PLATFORM=wayland
QT_QPA_PLATFORMTHEME=qt6ct
QT_QPA_PLATFORMTHEME_QT6=qt6ct
```

Make sure to run the following command the logout afterward:

```bash
systemctl --user daemon-reexec
```

### Languages

| Package         | Version  | Via    | Observation                                                                                                                                            |
| --------------- | -------- | ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `golang`        | >=1.25.8 | `dnf5` | Used to install system-wide tools under `/usr/bin`.                                                                                                    |
| `cargo`         | >=1.93.1 | `dnf5` | Used to install system-wide tools under `/usr/bin`.                                                                                                    |
| `uv`            | >=0.10.9 | `dnf5` | Used to install system-wide tools under `/usr/share/uv/tools`, symlinked to `/usr/bin`. Defaults to `python` >=3.14.3, which is the system default.                |
| `node-npm`      | >=10.9.4 | `dnf5` | Depends on `node` >=22.22.0, which is installed as a dependency. Let me know if you need `pnpm` or other node tooling that we currently don't include. |
| `just-lsp`      | >=0.4.0  | `dnf5` | Language server for your `justfile`.                                                                                                                   |
| `gopls`         | >=0.21.1 | `dnf5` | Language server for Go code.                                                                                                                           |
| `golangci-lint` | >=2.11.3 | `dnf5` | Can be integrated with `pre-commit` for Go code linting.                                                                                               |
| `shfmt`         | >=3.13.0 | `dnf5` | Can be used with your editor to format shell scripts.                                                                                                  |

### Shell

| Package          | Version  | Via     | Observation                                                                                                                                                                                                         |
| ---------------- | -------- | ------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `kitty`          | >=0.43.1 | `dnf5`  | GPU-accelerated terminal emulator. Highly customizable.                                                                                                                                                             |
| `fish`           | >=4.2.0  | `dnf5`  | Included in Bazzite by default.                                                                                                                                                                                     |
| `starfish`       | >=1.24.2 | `dnf5`  | Cross-shell prompt, with good defaults. Requires `atim/starship` COPR.                                                                                                                                              |
| `chezmoi`        | >=2.70   | `dnf5`  | Used to manage dotfiles. Take a look at the [DataLabTechTV/dotfiles](https://github.com/DataLabTechTV/dotfiles) repo for an example and instructions on how to use.                                                 |
| `direnv`         | >=2.35   | `dnf5`  | Utility to automatically load and unload `.envrc` or `.env` files per directory.                                                                                                                                    |
| `zoxide`         | >=0.9.8  | `dnf5`  | Useful `cd` replacement, with fuzzy matching and filtering.                                                                                                                                                         |
| `bat` (`batcat`) | >=0.25.0 | `dnf5`  | Replacement for `cat` with syntax highlighting and pager by default. You can also use it to improve readability for help messages (e.g., `cat --help \| bat -l help`) or man pages (e.g., `man cat \| bat -l man`). |
| `rg` (`ripgrep`) | >=14.1.1 | `dnf5`  | Recursive `grep` alternative. Generally more efficiency than `grep -r`.                                                                                                                                             |
| `fd` (`fd-find)` | >=10.4.2 | `dnf5`  | User-friendly find command. Good for quick file searching, but you might still prefer `find`, depending on the task.                                                                                                |
| `eza`            | >=0.23.4 | `cargo` | Beautified version of `ls`, with features like icons or tree listing.                                                                                                                                               |
| `ncdu`           | >=2.9.2  | `dnf5`  | Utility for recursively measuring storage, identifying largest directories. Useful for large file system cleanup.                                                                                                   |
| `prettyping`     | >=1.1.0  | `dnf5`  | Utility `ping` script useful for visually monitoring packet loss.                                                                                                                                                   |

### Network

| Package  | Version  | Via    | Observation                                                                                 |
| -------- | -------- | ------ | ------------------------------------------------------------------------------------------- |
| `rclone` | >=1.73.0 | `dnf5` | This is like the `rsync` for cloud storage. It can connect to wherever, from S3 to Dropbox. |
| `iperf3` | >=3.19.1 | `dnf5` | Useful to measure network bandwidth and performance.                                        |
| `mkcert` | >=1.4.4  | `dnf5` | Easily run your local CA to issue certificates.                                             |
| `nc`     | >=7.92   | `dnf5` | Swiss army knife for network communication.                                                 |
| `nmap`   | >=7.92   | `dnf5` | Port mapping software.                                                                      |
| `mc`     | dev      | `go`   | MinIO command line client.                                                                  |
| `s5cmd`  | dev      | `go`   | Another S3 client.                                                                          |
| `warp`   | dev      | `go`   | Benchmark software for S3 object stores, by MinIO.                                          |
| `httpie` | >=3.2.4  | `uv`   | Command line REST API request tool. We include support for SigV4.                           |

### Graphics

| Package             | Version    | Via    | Observation                                                                         |
| ------------------- | ---------- | ------ | ----------------------------------------------------------------------------------- |
| `ImageMagick-heic`  | >=7.1.1.47 | `dnf5` | ImageMagick support for HEIC format.                                                |
| `libheif-freeworld` | >=1.20.2   | `dnf5` | Only available on the  `rpmfusion-free` repo. Adds support for Apple's HEIC format. |
| `rembg[gpu,cli]`    | >=2.0.73   | `uv`   | AI tool to remove the background from photos.                                       |

### Dev

| Package               | Version   | Via    | Observation                                                                                             |
| --------------------- | --------- | ------ | ------------------------------------------------------------------------------------------------------- |
| `pre-commit`          | >=4.5.1   | `dnf5` | Useful to run linters and formatters before `git commit`.                                               |
| `cloc`                | >=2.08    | `dnf5` | Counts lines of code, so you can get some stats for your codebase.                                      |
| `delta` (`git-delta`) | >=0.18.2  | `dnf5` | A better diff for the CLI, with side-by-side support.                                                   |
| `nvim` (`neovim`)     | >=0.11.6  | `dnf5` | Replaces `vim-minimal`. Set as the default alternative for `vim` (i.e., `vim` command will run `nvim`). |
| `lazygit`             | >=0.60.0  | `dnf5` | Requires the `dejan/lazygit` COPR.                                                                      |
| `hugo`                | >=0.111.3 | `go`   | This is pinned to an older version that works with the [blowfish](https://blowfish.page/) theme.        |

### Containers

| Package                                   | Version  | Via    | Observation                                                                                                                                                                                                                     |
| ----------------------------------------- | -------- | ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `docker` (`docker-cli`)                   | >=29.3.0 | `dnf5` | Uses the user's Podman by default, via the corresponding socket, via the provided script.                                                                                                                                       |
| `docker-compose`(`docker-compose-switch`) | >=5.1.0  | `dnf5` | The `docker-compose` package is deprecated. This isn't a command to switch compose versions, but a new package they are switching to. Uses the user's Podman by default, via the corresponding socket, via the provided script. |
| `lazydocker`                              | >=0.25.0 | `go`   | TUI for docker.                                                                                                                                                                                                                 |
| `cosign`                                  | >=3.0.5  | `go`   | Used to sign container images, like this one.                                                                                                                                                                                   |

### AI

| Package  | Version  | Via              | Observation                     |
| -------- | -------- | ---------------- | ------------------------------- |
| `ollama` | >=0.18.2 | Official Archive | To run your LLM models locally. |

### Data

| Package          | Version  | Via              | Observation                                                                                  |
| ---------------- | -------- | ---------------- | -------------------------------------------------------------------------------------------- |
| `sqlite3`        |          | `dnf5`           | Embedded SQL database, with support for WAL.                                                 |
| `duckdb`         |          | Official Archive | Embedded SQL database, that works as a data lakehouse, supporting ETL and analytics locally. |
| `mlr` (`miller`) |          | `dnf5`           | CSV query tool.                                                                              |
| `yq`             | >=4.47.1 | `dnf5`           | YAML query tool similar to what `jq` is for JSON.                                            |
| `gnuplot`        |          | `dnf5`           | Command line plotting tool, with multiple charting options, that produce images.             |
| `termgraph`      |          | `uv`             | Command line plotting tool, that produces charts directly in the terminal.                   |
| `visidata`       |          | `uv`             | TUI for data exploration.                                                                    |

### Validations

We also include a validations script, where, at this point, we only validate the `/etc/niri/config.kdl` file.

# Acknowledgements

A big thanks to the helpful people at the Universal Blue Discord server, who promptly answered my questions on building a custom image of Bazzite.
