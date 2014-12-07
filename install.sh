#!/bin/sh
# Installs Kel's dotfiles on any Unix-like system.

cd `dirname $0` # Move to the directory of the dotfile repository

if [ -e oh-my-zsh/.git ] # If oh-my-zsh's repo's already been cloned
  then # Update the contents of it
    cd oh-my-zsh && git pull && cd ..
  else # Install oh-my-zsh
    git clone https://github.com/robbyrussell/oh-my-zsh.git
fi

# Source zsh and vim config files
touch $HOME/.zshrc && echo "source $(pwd)/zshrc" >> $HOME/.zshrc
touch $HOME/.vimrc && echo "source $(pwd)/vimrc" >> $HOME/.vimrc

# Copy our tmux config file over since idk how to use tmuxrc sourcing
echo "# WARNING! I'm a generated file!" > $HOME/.tmux.conf
echo "# I'm overwritten by my parent at $(pwd)" >> $HOME/.tmux.conf
echo "# Have a nice day!\n" >> $HOME/.tmux.conf
cat tmuxrc >> $HOME/.tmux.conf

echo "Configs are now copied to your home directory."
echo "Every time you open a terminal, this repo will be updated"
echo "and the new configs will be copied over.\n"

echo "If you move this repository, be sure to run install.sh again."
echo "Have a good day!\n"
