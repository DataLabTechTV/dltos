# --- antidote bundle ---
source /usr/share/zsh/antidote/plugins.zsh

# --- zsh-patina ---
if command -v zsh-patina >/dev/null 2>&1; then
    eval "$(zsh-patina activate)"
fi

# --- abbrev-alias ---
if command -v abbrev-alias >/dev/null 2>&1; then
    abbrev-alias --init
fi

# --- fzf ---
if command -v fzf >/dev/null 2>&1; then
    eval "$(fzf --zsh)"
fi

# --- zoxide ---
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
fi

# --- direnv ---
if command -v direnv >/dev/null 2>&1; then
    eval "$(direnv hook zsh)"
fi

# --- pyenv ---
if command -v pyenv >/dev/null 2>&1; then
    eval "$(pyenv init - zsh)"
fi

# --- fnm (Node version manager) ---
if command -v fnm >/dev/null 2>&1; then
    eval "$(fnm env --use-on-cd --shell zsh)"
fi

# --- cargo ---
if [[ -f "$HOME/.cargo/env" ]]; then
    source "$HOME/.cargo/env"
fi

# --- keychain (SSH agent) ---
if command -v keychain >/dev/null 2>&1; then
    ssh_keys=($HOME/.ssh/*.pub(N))

    if ((${#ssh_keys[@]} > 0)); then
        eval "$(keychain add --eval --quiet --immediate ${ssh_keys[@]%.pub})"
    fi
fi
