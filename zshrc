# Kel's ZSH config!

autoload -U compinit && compinit # Ultra basic tab completion
bindkey -v # Vim bindings for shell input
setopt COMPLETE_IN_WORD # Allow tab completion in the middle of a word
setopt EXTENDED_GLOB # Allow advanced regexp globbing
setopt NOBGNICE # Keep background processes at full speed
setopt NO_BEEP # Never ever beep ever
setopt PROMPT_SUBST # Substitute commands, parameters, arithmetic in prompt
PROMPT='$(promptchar)' # ZSH's PS1
RPROMPT='$(rightprompt)' # Right side prompt: pwd, vcs branch 
LISTMAX=0 # Automatically decide when to page a list of completions
REPORTTIME=5 # Print time statistics for processes that run longer than 5 secs
