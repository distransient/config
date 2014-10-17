#!/bin/sh

# Move to the directory of the repository
cd `dirname $0`

rm -rf oh-my-zsh
hash git >/dev/null 2>&1 && env git clone https://github.com/robbyrussell/oh-my-zsh.git || {
  echo "git not installed"
  exit
}

./update.sh

echo "Configs are now copied to your home directory."
echo "Every time you open a terminal, this repo will be updated"
echo "and the new configs will be copied over.\n"

echo "If you move this repository, be sure to run install.sh again!"
echo "Have fun!!!\n"
