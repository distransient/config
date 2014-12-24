# E N V I R O N M E N T
# → Locales
# → Default Applications
# → Colorizing Env Vars
# → Et Cetera 
# → ZSH specific

source $(dirname $0)/aliases # Source functions and default options

# ¶ Locales → US English & UTF 8 
export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"

# ¶ Default Applications
export PAGER="less" # Git diffs, man page viewer
export EDITOR="vim" && export VISUAL="vim" 
[ -n "$DISPLAY" ] && export BROWSER="google-chrome" || export BROWSER="links" 

# ¶ Colorizing Env Vars
export LESS_TERMCAP_mb="[38;5;013m" # Colorize less blinking mode
export LESS_TERMCAP_md="[38;5;013m" # Colorize less bold mode 
export LESS_TERMCAP_me="[00m" # Reset char for less so,us,mb,md,mr modes
export LESS_TERMCAP_so="[48;5;013m[38;5;000m" # Colorize less standout mode
export LESS_TERMCAP_se="[00m" # Reset char for less standout mode
export LESS_TERMCAP_us="[38;5;011m" # Colorize less underlining
export LESS_TERMCAP_ue="[00m" # Reset char for less underlining
export LS_COLORS="di=96:fi=0:ln=1;91:pi=1;95:so=1;95:bd=1;95:cd=1;95:or=1;91:mi=1;91:ex=1;95"
export GREP_COLOR="1;35" 

# ¶ Et Cetera
export LESSHISTFILE="/dev/null" # Disable less history saving
HISTFILE="~/.histfile" 
HISTSIZE="10000" 
SAVEHIST="10000" 
export HISTCONTROL="erasedups" # Ignore duplicate entries in history
export HISTIGNORE="&:ls:ll:la:l.:pwd:exit:clear:clr:[bf]g"
MAILCHECK="0" # Disable mail check notifications

if [ -z SHOPT ]; then
  shopt -s histappend # Append history instead of overwriting
  shopt -s cdspell # Correct minor spelling errors in cd command
  shopt -s dotglob # includes dotfiles in pathname expansion
  shopt -s checkwinsize # If window size changes, redraw contents
  shopt -s cmdhist # Multiline commands are a single command in history.
  shopt -s extglob # Allows basic regexps in bash.
fi

# ¶ ZSH specific
if [ -n "$ZSH_NAME" ]; then
  LISTMAX=0 # Automatically decide when to page a list of completions
  REPORTTIME=5 # Print time statistics for processes that run longer than 5 secs
fi
