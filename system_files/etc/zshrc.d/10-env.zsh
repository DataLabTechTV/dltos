# --- General ---
export SHELL=/usr/bin/zsh
export EDITOR=vim
export VISUAL=$EDITOR
export PAGER='less -X -F -i'

# --- Path ---
typeset -U path
path=(
	$HOME/.local/bin
	$HOME/go/bin
	$HOME/.cargo/bin
	$HOME/.pyenv/bin
	$HOME/.cabal/bin
	$HOME/.config/emacs/bin
	/usr/local/go/bin
	$path
)

# --- pyenv ---
export CLOUDSDK_PYTHON_SITEPACKAGES=1
export CLOUDSDK_PYTHON="$(command -v python)"

# --- podman ---
if command -v podman >/dev/null 2>&1; then
	export DOCKER_HOST="unix://$(podman info --format '{{.Host.RemoteSocket.Path}}')"
	export REGISTRY_AUTH_FILE="$HOME/.config/containers/auth.json"
fi

# --- homebrew ---
export HOMEBREW_NO_ENV_HINTS=1
