
if [[ -f `which viewer` ]]; then
    alias ls="viewer"
else
    echo "bash config: viewer not installed, not creating alias"
fi

