# GIT PROMPT
_prompt_icon='>>'
_branch_icon=$'\uf126'
_ref_maxlen=20
_set_prompt(){
    local ref git_repo=""
    if ref=$(git symbolic-ref -q --short HEAD 2>/dev/null) \
        || ref=$(git rev-parse -q --short HEAD 2>/dev/null); then
        local st line idx wt c=92 conflict=0 staged=0 unstaged=0 untracked=0
        st=$(git status --porcelain 2>/dev/null)
        while IFS= read -r line; do
            [[ -n $line ]] || continue
            idx=${line:0:1} wt=${line:1:1}
            if [[ $idx == U || $wt == U || $idx$wt == DD || $idx$wt == AA ]]; then
                conflict=1
            elif [[ $idx == '?' ]]; then
                untracked=1
            else
                [[ $idx != ' ' ]] && staged=1
                [[ $wt != ' ' ]] && unstaged=1
            fi
        done <<< "$st"

        # red conflict > yellow unstaged > cyan staged > magenta untracked > green clean
        if   (( conflict ));  then c=91
        elif (( unstaged ));  then c=93
        elif (( staged ));    then c=96
        elif (( untracked )); then c=95
        fi
        (( ${#ref} > _ref_maxlen )) && ref="${ref:0:_ref_maxlen-1}"$'…'
        git_repo="(\[\e[4;${c}m\]${_branch_icon} $ref\[\e[0m\]) "
    fi
    PS1="\[\e[3;32m\h\e[0m\]\[\e[1;30m\$:\e[0m\]\[\e[1;34m\]\w\[\e[0m\] ${git_repo}\[\e[1;30m${_prompt_icon}\e[0m\] "
}
PROMPT_COMMAND=_set_prompt
