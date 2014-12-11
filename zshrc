# Kel's ZSH config!
# Sections:
# → Zsh/General Shell
# → Functions and Aliases
# → Updating
# → Initialization 

# ¶ Zsh/General Shell
for file in $(dirname $0)/lib/*.zsh; do source "$file"; done # Load libraries
autoload -U compinit && compinit # Ultra basic tab completion
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}" # Tab completion color
bindkey -v # Vim bindings for shell input
setopt PROMPT_SUBST # Substitute commands, parameters, arithmetic in prompt
setopt COMPLETE_IN_WORD # Allow tab completion in the middle of a word
setopt EXTENDED_GLOB # Allow advanced regexp globbing
setopt CORRECT # Prompt to correct possibly misspelled commands
setopt NOBGNICE # Keep background processes at full speed
setopt NO_BEEP # Never ever beep ever
REPORTTIME=5 # Print time statistics for processes that run longer than 5 secs
LISTMAX=0 # Automatically decide when to page a list of completions
MAILCHECK=0 # Disable mail checking
HISTFILE=~/.histfile # Location to store shell history
HISTSIZE=10000 # It... It's... 
SAVEHIST=10000 # OVER NINE THOUSAAAAND
#export BROWSER="google-chrome"
export EDITOR="vim"
[ -z $BACKGROUND ] && BACKGROUND="dark" # Default background value
precmd() { 
  if [ -n "$(git branch 2> /dev/null)" ]; then
    if [ -n "$(git status --porcelain)" ]; then
      PROMPT="%F{yellow} ♆  %f"
    else
      PROMPT="%F{green} ♆  %f"
    fi
  elif [ -n "$(hg root 2> /dev/null)" ]; then
    PROMPT=" ☿  " # todo...
  elif [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
    PROMPT="%F{blue} ⇢  %f"
  else
    PROMPT="%F{green} →  %f"
  fi
}
RPROMPT="%~"
 
# ¶ Functions and Aliases
alias grep="grep --color=auto" # Colorify printed greps
s() { find -exec grep -n "$*" {} + 2> /dev/null } # Text search
b() { cd $(git rev-parse --show-cdup) } # Cd to root of current repo
alias f="find -name" # Search for file with name foo
alias ls="ls -GF" # ls with color (tfw no gf)
alias l="ls -GF" # Lazy shorthand
alias la="ls -aFGhl" # ls as list all
alias ll="ls -FGhl" # ls list non-hidden
alias cp="cp -iv" # Prompt before overwrite, verbose copy 
alias mv="mv -iv" # Prompt before overwrite, verbose move
alias rm="rm -iv" # Prompt before delete, verbose deletion 
alias tmux="tmux -2u" # Force 256 color/unicode tmux 
alias vim="vim -p" # Allows multiple arguments to be opened as tabs
alias v="vim -p" # Lazy shorthand
ci() { git add -A && git commit -am "$*" } # commit all changes in repo
# Colored man pages
man() { env LESS_TERMCAP_mb=$(printf "\e[1;31m") \
    LESS_TERMCAP_md=$(printf "\e[1;31m") LESS_TERMCAP_me=$(printf "\e[0m") \
    LESS_TERMCAP_se=$(printf "\e[0m") LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
    LESS_TERMCAP_ue=$(printf "\e[0m") LESS_TERMCAP_us=$(printf "\e[1;32m") \
    man "$@" }

# ¶ Updating
cd $(dirname $0) && git pull &> /dev/null && cd $HOME

# ¶ Initialization
[ -n "$TMUX" ] || tmux a || tmux
# If we're in ssh, make the tmux session look different 
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  tmux set status-bg yellow &> /dev/null
  tmux set status-fg black &> /dev/null
fi
