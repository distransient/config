# .bashrc
# Executed upon creation of interactive, non-login terminal.

# Source Global Definitions
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

# Modified Behavior
alias nano="nano --nowrap --mouse --autoindent"
alias df="df -h" # human readable space usage
alias du="du -c -h" # human readable, grand total usage

# Modified Appearance
if [ -f /usr/bin/colordiff ]; then
  alias diff="colordiff"
fi
alias grep="grep --color=auto"
alias ls="ls -hF --color=auto"

# We All Make Mistakes
alias :q="exit"
alias cd..="cd .."
alias ..="cd .."
