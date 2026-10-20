ctar() {
    if [ "$#" -lt 2 ]; then
        echo "usage: ctar <gz|xz> <directory> [tar-flags...]" >&2
        return 64
    fi
    local mode="$1" target="$2" zflag; shift 2
    case "$mode" in
        gz) zflag="-z" ;;
        xz) zflag="-J" ;;
        *) echo "Invalid mode: \"$mode\". Must be one of: \"gz\", \"xz\"" >&2; return 22 ;;
    esac
    if [ ! -d "$target" ]; then
        echo "\"$target\" does not exist or is not a directory" >&2
        return 2
    fi
    local compname="$(basename -- "$(realpath -- "$target")").tar.$mode"
    if [ -e "$compname" ]; then
        echo "Compressed archive \"$compname\" already exists" >&2
        return 1
    fi
    tar -c "$zflag" "$@" -f "$compname" -- "$target"
}

xtar() {
    local del=0
    if [ "${1-}" = "-d" ]; then del=1; shift; fi
    if [ "$#" -lt 1 ]; then
        echo "usage: xtar [-d] <archive> [tar-flags...]" >&2
        return 64
    fi
    local compname="$1" top tops=() existing=(); shift
    case "$compname" in
        *.tar.gz|*.tgz|*.tar.xz|*.txz) ;;
        *) echo "Unrecognized archive \"$compname\". Must end in: .tar.gz, .tgz, .tar.xz, .txz" >&2; return 22 ;;
    esac
    if [ ! -f "$compname" ]; then
        echo "Compressed archive \"$compname\" does not exist or is not a file" >&2
        return 2
    fi
    while IFS= read -r top; do
        [ -n "$top" ] || continue
        tops+=("$top")
        [ -e "$top" ] && existing+=("$top")
    done < <(tar -tf "$compname" | sed 's#^\./##; s#/.*##' | sort -u)
    if [ "${#tops[@]}" -eq 0 ]; then
        echo "Compressed archive \"$compname\" contains no entries (empty or corrupt)" >&2
        return 2
    fi
    if [ "${#existing[@]}" -gt 0 ]; then
        printf '"%s" already exists\n' "${existing[@]}" >&2
        return 1
    fi
    tar -x "$@" -f "$compname" || return
    [ "$del" -eq 1 ] && rm -f -- "$compname"
    return 0
}
