source /etc/zsh/env.zsh
source /etc/zsh/options.zsh

[[ -o interactive ]] || return

fpath=("/etc/zsh/functions" $fpath)
autoload -Uz /etc/zsh/functions/*(N:t)

source /etc/zsh/aliases.zsh
source /etc/zsh/completion.zsh
source /etc/zsh/keybinds.zsh
source /etc/zsh/plugins.zsh
source /etc/zsh/prompt.zsh
