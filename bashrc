# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Fancy Shell Prompt
Purple="$(tput setaf 5)" # Purple
Cyan="$(tput setaf 6)" # Cyan
Green="$(tput setaf 2)" # Green
Blue="$(tput setaf 4)" # Blue
NC="$(tput sgr0)" # No Color
PS1='\[$Purple\][\[$Cyan\]\u\[$Purple\]@\[$Green\]\h \[$Blue\]\w \[$Purple\]]\[$NC\]\$ '
