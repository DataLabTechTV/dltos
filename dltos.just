term_width := `tput cols`
delta := "delta --side-by-side --paging=never --width=" + term_width

# (Re)generates the fastfetch ASCII logo from an image
[group('DLT OS')]
update-ascii-logo $png="system_files/usr/share/dltos/logo.png" $ascii="system_files/usr/share/dltos/logo.txt":
    #!/usr/bin/env bash
    set -euxo pipefail
    # Check if ascii-image-converter is installed
    if ! command -v ascii-image-converter &> /dev/null; then
        echo "ascii-image-converter could not be found. Please install it."
        exit 1
    fi
    ascii-image-converter $png -d 36,19 -C > $ascii
    tmp=$(mktemp)
    trap 'rm -f "$tmp"' EXIT
    sed 's/^/ /' $ascii > $tmp
    mv $tmp $ascii

_diff-user-configs $app $user_dir="":
    #!/usr/bin/env bash
    defaults_dir="system_files/usr/share/$app/defaults"
    default_files=$(find "$defaults_dir" -type f | sed "s|$defaults_dir/||")
    for file in $default_files; do
        default_file="$defaults_dir/$file"
        if [ -z "$user_dir" ]; then
            user_dir="$HOME/.config/$app"
        fi
        user_file="$user_dir/$file"
        {{ delta }} "$default_file" "$user_file"
    done | less -R
    exit 0

# Diff image neovim configs and user configs
[group('DLT OS')]
diff-nvim-user-configs:
    @just _diff-user-configs nvim

# Diff image emacs configs and user configs
[group('DLT OS')]
diff-emacs-user-configs:
    @just _diff-user-configs emacs "$HOME/.config"

# Diff image gamescope configs and user configs
[group('DLT OS')]
diff-gamescope-user-configs:
    @just _diff-user-configs gamescope "$HOME/.config/environment.d"

# Diff image konsole configs and user configs
[group('DLT OS')]
diff-konsole-user-configs:
    @just _diff-user-configs konsole "$HOME/.config"

# Diff image niri configs and user configs
[group('DLT OS')]
diff-niri-user-configs:
    @just _diff-user-configs niri

# Diff image zed configs and user configs
[group('DLT OS')]
diff-zed-user-configs:
    @just _diff-user-configs zed

# Diff all image configs and user configs
[group('DLT OS')]
diff-all-user-configs:
    #!/usr/bin/env bash
    (
        just diff-nvim-user-configs
        just diff-emacs-user-configs
        just diff-gamescope-user-configs
        just diff-konsole-user-configs
        just diff-niri-user-configs
        just diff-zed-user-configs
    ) | less -R

_import-user-configs $app $user_dir="":
    #!/usr/bin/env bash
    defaults_dir="system_files/usr/share/$app/defaults"
    default_files=$(find "$defaults_dir" -type f | sed "s|$defaults_dir/||")
    for file in $default_files; do
        default_file="$defaults_dir/$file"
        if [ -z "$user_dir" ]; then
            user_dir="$HOME/.config/$app"
        fi
        user_file="$user_dir/$file"
        cp -v "$user_file" "$default_file"
    done
    exit 0

# Replace image neovim configs with user configs
[group('DLT OS')]
import-nvim-user-configs:
    @just _import-user-configs nvim

# Replace image emacs configs with user configs
[group('DLT OS')]
import-emacs-user-configs:
    @just _import-user-configs emacs "$HOME/.config"

# Replace image gamescope configs with user configs
[group('DLT OS')]
import-gamescope-user-configs:
    @just _import-user-configs gamescope "$HOME/.config/environment.d"

# Replace image konsole configs with user configs
[group('DLT OS')]
import-konsole-user-configs:
    @just _import-user-configs konsole "$HOME/.config"

# Replace image niri configs with user configs
[group('DLT OS')]
import-niri-user-configs:
    @just _import-user-configs niri

# Import image zed configs with user configs
[group('DLT OS')]
import-zed-user-configs:
    @just _import-user-configs zed

# Replace all image configs with user configs
[group('DLT OS')]
import-all-user-configs: import-nvim-user-configs import-emacs-user-configs import-gamescope-user-configs \
    import-konsole-user-configs import-niri-user-configs import-zed-user-configs
