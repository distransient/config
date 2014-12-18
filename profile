# ¶ US English & UTF 8 Locale settings
export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"

# ¶ Default Applications
export EDITOR="vim" && export VISUAL="vim" 
if [ -n "$DISPLAY" ]; then 
  export BROWSER="google-chrome" 
else 
  export BROWSER="links" # shell web browser
fi
export PAGER="less" # Git diffs, man page viewer

# ¶ Colorizing Env Vars
export LESS_TERMCAP_mb="$FG[013]" # Colorize less blinking mode
export LESS_TERMCAP_md="$FG[013]" # Colorize less bold mode 
export LESS_TERMCAP_me="$FX[reset]" # Reset char for less so,us,mb,md,mr modes
export LESS_TERMCAP_so="$BG[013]$FG[000]" # Colorize less standout mode
export LESS_TERMCAP_se="$FX[reset]" # Reset char for less standout mode
export LESS_TERMCAP_us="$FG[011]" # Colorize less underlining
export LESS_TERMCAP_ue="$FX[reset]" # Reset char for less underlining
export LS_COLORS="di=96:fi=0:ln=1;91:pi=1;95:so=1;95:bd=1;95:cd=1;95:or=1;91:mi=1;91:ex=1;95"

# ¶ Random
MAILCHECK=0 # Disable mail check notifications
HISTFILE=~/.histfile && HISTSIZE=10000 && SAVEHIST=10000 # Shell history

# ¶ ZSH specific
if [ -n "$ZSH_NAME" ]; then
  LISTMAX=0 # Automatically decide when to page a list of completions
  REPORTTIME=5 # Print time statistics for processes that run longer than 5 secs
fi
