# Kel's ZSH config!

source $(dirname $0)/profile # Source env vars just in case
for file in $(dirname $0)/lib/*.zsh; do source "$file"; done # Load libraries
autoload -U compinit && compinit # Ultra basic tab completion
bindkey -v # Vim bindings for shell input
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}" # Tab completion color
setopt COMPLETE_IN_WORD # Allow tab completion in the middle of a word
setopt EXTENDED_GLOB # Allow advanced regexp globbing
setopt CORRECT # Prompt to correct possibly misspelled commands
setopt NOBGNICE # Keep background processes at full speed
setopt NO_BEEP # Never ever beep ever
setopt PROMPT_SUBST # Substitute commands, parameters, arithmetic in prompt
vcscurrent(){
  [ -n "$(git branch 2> /dev/null)" ] && echo "git" || \
  [ -n "$(hg root 2> /dev/null)" ] && echo "hg"
}
vcsbranch(){
  [ -n "$(git branch 2> /dev/null)" ] && \
    echo $(git symbolic-ref --short -q HEAD 2> /dev/null) || \
  [ -n "$(hg root 2> /dev/null)" ] && \
    echo $(hg branch 2> /dev/null)
}
vcsdirty(){
  [ -n "$(git branch 2> /dev/null)" ] && \
    [ -n "$(git status --porcelain 2> /dev/null)" ] && \
      echo "dirty" || \
  [ -n "$(hg root 2> /dev/null)" ] && \
    [ -n "$(hg status 2> /dev/null)" ] && \
      echo "dirty"
}

_promptfunc(){
  # Check for vcs
  [ -n "$(vcscurrent)" ] && ( [ -n "$(vcsdirty)" ] && \
      echo "$(vcsbranch) ?" || echo "$(vcsbranch) =" \
  # Check for ssh 
  ) || ([ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ] && \
    echo "%(!:&:@)") || echo "%(!:&:#)"
}
PROMPT='%{%(?:$FG[011]:$FG[009])$FX[bold]%} $(_promptfunc) %f'
RPROMPT="%~" # Current directory right side prompt
 
[ -n "$TMUX" ] || tmux a || tmux # Automatically attach to tmux
