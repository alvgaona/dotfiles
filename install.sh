#!/bin/sh
set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

link() {
    src="$1"
    dst="$2"
    mkdir -p "$(dirname "$dst")"
    if [ -L "$dst" ]; then
        rm "$dst"
    elif [ -e "$dst" ]; then
        echo "backup: $dst -> ${dst}.bak"
        mv "$dst" "${dst}.bak"
    fi
    ln -s "$src" "$dst"
    echo "linked: $dst -> $src"
}

link "$DOTFILES/zsh/zshrc"                "$HOME/.zshrc"
link "$DOTFILES/zsh/zshenv"               "$HOME/.zshenv"
link "$DOTFILES/zsh/zprofile"             "$HOME/.zprofile"
link "$DOTFILES/zsh/zsh_aliases"          "$HOME/.zsh_aliases"
link "$DOTFILES/zsh/zsh_functions/rosenv" "$HOME/.zsh_functions/rosenv"
link "$DOTFILES/starship/starship.toml"   "$HOME/.config/starship.toml"

mkdir -p "$HOME/.cache/zsh"

if command -v starship >/dev/null 2>&1; then
    starship init zsh --print-full-init > "$HOME/.cache/starship-init.zsh"
    echo "cached: starship init"
fi

if command -v zoxide >/dev/null 2>&1; then
    zoxide init zsh > "$HOME/.cache/zoxide-init.zsh"
    echo "cached: zoxide init"
fi

echo "done"
