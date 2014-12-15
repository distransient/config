# Kel's ZSH config!
# Sections:
# → Zsh/General Shell
# → Functions and Aliases
# → Initialization 

for file in $(dirname $0)/lib/*.zsh; do source "$file"; done # Load libraries

# ¶ Zsh/General Shell
autoload -U compinit && compinit # Ultra basic tab completion
bindkey -v # Vim bindings for shell input
setopt PROMPT_SUBST # Substitute commands, parameters, arithmetic in prompt
setopt COMPLETE_IN_WORD # Allow tab completion in the middle of a word
setopt EXTENDED_GLOB # Allow advanced regexp globbing
setopt CORRECT # Prompt to correct possibly misspelled commands
setopt NOBGNICE # Keep background processes at full speed
setopt NO_BEEP # Never ever beep ever
export LESS_TERMCAP_mb="$FG[013]" # Colorize less blinking mode
export LESS_TERMCAP_md="$FG[013]" # Colorize less bold mode 
export LESS_TERMCAP_me="$FX[reset]" # Reset char for less so,us,mb,md,mr modes
export LESS_TERMCAP_so="$BG[013]$FG[000]" # Colorize less standout mode
export LESS_TERMCAP_se="$FX[reset]" # Reset char for less standout mode
export LESS_TERMCAP_us="$FG[011]" # Colorize less underlining
export LESS_TERMCAP_ue="$FX[reset]" # Reset char for less underlining
export LS_COLORS="di=96:fi=0:ln=1;91:pi=1;95:so=1;95:bd=1;95:cd=1;95:or=1;91:mi=1;91:ex=1;95"
export BROWSER="google-chrome" # Default web browser
export EDITOR="vim" # Default editor
precmd() { 
  if [ -n "$(git branch 2> /dev/null)" ]; then
    if [ -n "$(git status --porcelain 2> /dev/null)" ] 
      then PROMPT="%{%(?:$FG[011]:$FG[009])$FX[bold]%} ? %f"
      else PROMPT="%{%(?:$FG[011]:$FG[009])$FX[bold]%} = %f"
    fi
  elif [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
    PROMPT="%{%(?:$FG[011]:$FG[009])$FX[bold]%} %(!:&:@) %f"
  else
    PROMPT="%{%(?:$FG[011]:$FG[009])$FX[bold]%} %(!:&:#) %f"
  fi
}
RPROMPT="%~" # Current directory right side prompt
REPORTTIME=5 # Print time statistics for processes that run longer than 5 secs
LISTMAX=0 # Automatically decide when to page a list of completions
MAILCHECK=0 # Disable mail checking
HISTFILE=~/.histfile && HISTSIZE=10000 && SAVEHIST=10000 # Shell history

zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}" # Tab completion color
 
# ¶ Functions and Aliases
s() { find -exec grep -n "$*" {} + 2> /dev/null } # Text search
b() { cd $(git rev-parse --show-cdup) } # Cd to root of current repo
ci() { git add -A && git commit -am "$*" } # commit all changes in repo
alias grep="grep --color=auto" # Colorify printed greps
alias f="find -name" # Search for file with name foo
alias ls="ls -F --color" # ls with color 
alias l="ls -F --color" # Lazy shorthand
alias la="ls -aFhl --color" # ls as list all
alias ll="ls -Fhl --color" # ls list non-hidden
alias cp="cp -iv" # Prompt before overwrite, verbose copy 
alias mv="mv -iv" # Prompt before overwrite, verbose move
alias rm="rm -iv" # Prompt before delete, verbose deletion 
alias tmux="tmux -2u" # Force 256 color/unicode tmux 
alias vim="vim -p" # Allows multiple arguments to be opened as tabs
alias v="vim -p" # Lazy shorthand

# ¶ Initialization
cd $(dirname $0) && git pull 1> /dev/null 
cd $HOME
[ -n "$TMUX" ] || tmux a || tmux
