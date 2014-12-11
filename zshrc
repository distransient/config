# Kel's ZSH config!
# Sections:
# → Zsh/General Shell
# → Oh-my-zsh!-Specific
# → Functions and Aliases
# → Updating
# → Initialization 

# ¶ Zsh/General Shell
for file in $(dirname $0)/lib/*.zsh; do source "$file"; done # Load libraries
autoload -U compinit && compinit # Ultra basic tab completion
bindkey -v # Vim bindings for input
setopt COMPLETE_IN_WORD # Allow tab completion in the middle of a word
setopt EXTENDED_GLOB # Allow advanced regexp globbing
setopt CORRECT # Prompt to correct possibly misspelled commands
setopt PROMPT_SUBST # Substitute commands, parameters, arithmetic in prompt
setopt NOBGNICE # Keep background processes at full speed
setopt NO_BEEP # Never ever beep ever
LISTMAX=0 # Automatically decide when to page a list of completions
MAILCHECK=0 # Disable mail checking
[ -z $BACKGROUND ] && BACKGROUND="dark" # Default background value
PROMPT="%{$(pwd|grep --color=always /)%${#PWD}G%} %(!.%F{red}.%F{cyan})%n%f@%F{yellow}%m%f%(!.%F{red}.)%#%f  "

# ¶ Oh-my-zsh!-Specific
#plugins=(git) # oh-my-zsh plugins
#ZSH_THEME="robbyrussell" # oh-my-zsh theme
#DISABLE_UPDATE_PROMPT=true # don't prompt to update oh-my-zsh
#export ZSH=`dirname $0`/oh-my-zsh # Path to oh-my-zsh install.
#source $ZSH/oh-my-zsh.sh # Run oh-my-zsh scripts
 
# ¶ Functions and Aliases
s() { find -exec grep -n "$*" {} + 2> /dev/null } # Text search
b() { cd $(git rev-parse --show-cdup) } # Cd to root of current repo
alias f="find -name" # Search for file with name foo
alias tmux="tmux -2u" # Force 256 color/unicode tmux 
alias vim="vim -p" # Allows multiple arguments to be opened as tabs
alias v="vim -p" # Lazy shorthand
ci() { git add -A && git commit -am "$*" } # commit all changes in repo

# ¶ Updating
cd $(dirname $0) && git pull &> /dev/null && cd $HOME

# ¶ Initialization
[ -n "$TMUX" ] || tmux a || tmux
# If we're in ssh, make the tmux session look different 
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  tmux set status-bg yellow &> /dev/null
  tmux set status-fg black &> /dev/null
fi
