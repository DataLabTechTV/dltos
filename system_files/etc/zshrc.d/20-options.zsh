unsetopt beep

# --- history ---
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=100000
HISTDUP=erase
setopt appendhistory
setopt sharedhistory
setopt hist_ignore_space
setopt hist_find_no_dups

# --- word breaks ---
WORDCHARS=''
