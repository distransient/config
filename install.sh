#!/bin/sh
# Installs Kel's dotfiles on any Unix-like system.

cd `dirname $0` # Move to the directory of the dotfile repository

if [ -e oh-my-zsh/.git ] # If oh-my-zsh's repo's already been cloned
  then # Update the contents of it
    cd oh-my-zsh && git pull && cd ..
  else # Install oh-my-zsh
    git clone https://github.com/robbyrussell/oh-my-zsh.git
fi

touch $HOME/.zshrc && echo "source $(pwd)/zshrc" >> $HOME/.zshrc
touch $HOME/.vimrc && echo "source $(pwd)/vimrc" >> $HOME/.vimrc
touch $HOME/.tmux.conf && echo "source $(pwd)/tmuxrc" >> $HOME/.tmux.conf

echo ""
echo "Configs are now sourced by ~/.zshrc, ~/.vimrc, and ~/.tmux.conf"
echo "  to the files in this directory. Whenever a new shell is opened,"
echo "  the configs within this directory are updated. However, if you"
echo "  move this directory, be sure to update your homedir's configs to"
echo "  point to the new location."
echo ""
echo "Have a nice day!"
echo ""
