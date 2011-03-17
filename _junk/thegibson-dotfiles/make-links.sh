#!/bin/sh


[[ ! -f "$HOME/.bash_profile" ]] && ln -s "$HOME/dotfiles/bash_profile" "$HOME/.bash_profile"
[[ ! -f "$HOME/.bashrc" ]] && ln -s "$HOME/dotfiles/basrc" "$HOME/.bashrc"
[[ ! -f "$HOME/.bash-aliases" ]] && ln -s "$HOME/dotfiles/bash-aliases" "$HOME/.bash-aliases"
[[ ! -f "$HOME/.exrc" ]] && ln -s "$HOME/dotfiles/exrc" "$HOME/.exrc"
echo "done.  (for those files that existed nothing was done.)"

