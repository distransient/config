# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# Fancy Shell Prompt
Purple="$(tput setaf 5)" 
Cyan="$(tput setaf 6)" 
Green="$(tput setaf 2)" 
Blue="$(tput setaf 4)" 
NC="$(tput sgr0)" # No Color
PS1='\[$Purple\][\[$Cyan\]\u\[$Purple\]@\[$Green\]\h \[$Blue\]\w \[$Purple\]]\[$NC\]\$ '
