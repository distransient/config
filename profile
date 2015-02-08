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
