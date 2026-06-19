unalias ls 2>/dev/null

abbrev-alias ff='fastfetch'
abbrev-alias pp='prettyping'

abbrev-alias v='vim'
abbrev-alias d='distrobox'
abbrev-alias c='chezmoi'
abbrev-alias p='podman'
abbrev-alias j='just'

alias pbcopy='wl-copy --type text/plain'
alias pbpaste='wl-paste'

# --- Git ---
alias gsw='git update-index --skip-worktree'
alias gnsw='git update-index --no-skip-worktree'
alias gswls='git ls-files -v | grep ^S'

# --- Kubernetes ---
abbrev-alias m='minikube'
abbrev-alias k='kubectl'
abbrev-alias kns='kubens'

# --- Global Aliases ---
abbrev-alias -g N='&>/dev/null'
