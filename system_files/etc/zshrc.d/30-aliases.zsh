unalias ls 2>/dev/null

abbrev-alias ff='fastfetch'
abbrev-alias v='vim'
abbrev-alias pp='prettyping'

alias pbcopy='wl-copy --type text/plain'
alias pbpaste='wl-paste'

# --- Distrobox ---
abbrev-alias d='distrobox'

# --- Chezmoi ---
abbrev-alias c='chezmoi'

# --- Git ---
alias gsw='git update-index --skip-worktree'
alias gnsw='git update-index --no-skip-worktree'
alias gswls='git ls-files -v | grep ^S'

# --- Kubernetes ---
abbrev-alias m='minikube'
abbrev-alias k='kubectl'
abbrev-alias kns='kubens'

# --- Global ---
abbrev-alias -g N='&>/dev/null'
