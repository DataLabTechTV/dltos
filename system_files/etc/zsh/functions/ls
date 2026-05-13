function ls() {
  if ! command -v eza &>/dev/null; then
    command ls --color "$@"
    return 0
  fi

  local args=()
  for arg in "$@"; do
    if [[ $arg =~ ^-[^-]{2,} ]]; then
      local compound_flags="${arg:1}"
      for ((i = 0; i < ${#compound_flags}; i++)); do
        local char="${compound_flags:$i:1}"
        if [[ $char == t ]]; then
          args+=(-s oldest)
        else
          args+=(-$char)
        fi
      done
    elif [[ $arg == -t ]]; then
      args+=(-s oldest)
    else
      args+=($arg)
    fi
  done

  eza --icons --group-directories-first --binary --group "${args[@]}"
}
