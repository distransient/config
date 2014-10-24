#!/bin/sh

# Get this repo's directory
REPO=`pwd`/`dirname $0`

$REPO/clean.sh

# Copy config files to homedir
echo "# Warning! This is a generated file!" > $HOME/.zshrc
echo "# It is overwritten by its parent at $REPO\n" >> $HOME/.zshrc
cat $REPO/zshrc >> $HOME/.zshrc

echo "# Warning! This is a generated file!" > $HOME/.tmux.conf
echo "# It is overwritten by its parent at $REPO\n" >> $HOME/.tmux.conf
cat $REPO/tmuxrc >> $HOME/.tmux.conf

echo "\" Warning! This is a generated file!" > $HOME/.vimrc
echo "\" It is overwritten by its parent at $REPO\n" >> $HOME/.vimrc
cat $REPO/vimrc >> $HOME/.vimrc

# Append repo-specifics to zshrc
echo "export ZSH=$REPO/oh-my-zsh # Path to oh-my-zsh install." >> $HOME/.zshrc
echo "source \$ZSH/oh-my-zsh.sh # Run oh-my-zsh scripts." >> $HOME/.zshrc

echo "\n# Update config files when opening a shell." >> $HOME/.zshrc
echo "cd $REPO && git pull &> /dev/null && ./update.sh && cd \$HOME" >> $HOME/.zshrc

