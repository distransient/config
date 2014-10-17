# Ultra basic tab completion
autoload -U compinit
compinit

# Random zsh settings
setopt COMPLETE_IN_WORD # Allow tab completion in the middle of a word
setopt NOBGNICE # Keep background processes at full speed
setopt NO_BEEP # Never ever beep ever
LISTMAX=0 # Automatically decide when to page a list of completions
MAILCHECK=0 # Disable mail checking

# oh-my-zsh! settings
plugins=(git) # oh-my-zsh plugins
ZSH_THEME="robbyrussell" # oh-my-zsh theme
