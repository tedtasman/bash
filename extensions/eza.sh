if [[ -f `which eza` ]]; then
    alias ls='eza'
    alias ll='eza -l --no-permissions --no-user --no-filesize --time-style=relative --group-directories-first'
    alias llr='eza -l --no-permissions --no-user --no-filesize --time-style=relative --group-directories-first --sort=modified --reverse'
    alias llq='eza -l --no-permissions --no-user --no-filesize --time-style=relative --group-directories-first --no-time'
    alias llg='eza -l --no-permissions --no-user --no-filesize --time-style=relative --git-repos --git --group-directories-first'
    alias llz='eza -l --total-size --time-style=iso'
    alias lsd='eza -D'
    alias lsf='eza -f'
    alias lld='eza -lD --no-permissions --no-user --no-filesize --time-style=relative --group-directories-first'
    alias llf='eza -lf --no-permissions --no-user --no-filesize --time-style=relative --group-directories-first'
else
    echo "bash config: eza not installed, using ls"
fi
