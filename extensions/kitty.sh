kitty() { local f="$1"; shift; cat "$f" | head "$@"; }
yttik() { local f="$1"; shift; cat "$f" | tail "$@";  }
