#!/usr/bin/env zsh
# -------------------------------------------------------------------------------------------------
# Copyright (c) 2010-2011 zsh-syntax-highlighting contributors
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification, are permitted
# provided that the following conditions are met:
#
#  * Redistributions of source code must retain the above copyright notice, this list of conditions
#    and the following disclaimer.
#  * Redistributions in binary form must reproduce the above copyright notice, this list of
#    conditions and the following disclaimer in the documentation and/or other materials provided
#    with the distribution.
#  * Neither the name of the zsh-syntax-highlighting contributors nor the names of its contributors
#    may be used to endorse or promote products derived from this software without specific prior
#    written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
# FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
# IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
# OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# -------------------------------------------------------------------------------------------------
# -*- mode: zsh; sh-indentation: 2; indent-tabs-mode: nil; sh-basic-offset: 2; -*-
# vim: ft=zsh sw=2 ts=2 et
# -------------------------------------------------------------------------------------------------
# Source: https://github.com/zsh-users/zsh-syntax-highlighting

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor root line)

# -------------------------------------------------------------------------------------------------
# Core highlighting update system
# -------------------------------------------------------------------------------------------------

# Array declaring active highlighters names.
typeset -ga ZSH_HIGHLIGHT_HIGHLIGHTERS

# Update ZLE buffer syntax highlighting.
#
# Invokes each highlighter that needs updating.
# This function is supposed to be called whenever the ZLE state changes.
_zsh_highlight()
{
  setopt localoptions nowarncreateglobal

  # Store the previous command return code to restore it whatever happens.
  local ret=$?

  # Do not highlight if there are more than 300 chars in the buffer. It's most
  # likely a pasted command or a huge list of files in that case..
  [[ -n ${ZSH_HIGHLIGHT_MAXLENGTH:-} ]] && [[ $#BUFFER -gt $ZSH_HIGHLIGHT_MAXLENGTH ]] && return $ret

  # Do not highlight if there are pending inputs (copy/paste).
  [[ $PENDING -gt 0 ]] && return $ret

  # Reset region highlight to build it from scratch
  region_highlight=();

  {
    local cache_place
    local -a region_highlight_copy

    # Select which highlighters in ZSH_HIGHLIGHT_HIGHLIGHTERS need to be invoked.
    local highlighter; for highlighter in $ZSH_HIGHLIGHT_HIGHLIGHTERS; do

      # eval cache place for current highlighter and prepare it
      cache_place="_zsh_highlight_${highlighter}_highlighter_cache"
      typeset -ga ${cache_place}

      # If highlighter needs to be invoked
      if "_zsh_highlight_${highlighter}_highlighter_predicate"; then

        # save a copy, and cleanup region_highlight
        region_highlight_copy=("${region_highlight[@]}")
        region_highlight=()

        # Execute highlighter and save result
        {
          "_zsh_highlight_${highlighter}_highlighter"
        } always {
          eval "${cache_place}=(\"\${region_highlight[@]}\")"
        }

        # Restore saved region_highlight
        region_highlight=("${region_highlight_copy[@]}")

      fi

      # Use value form cache if any cached
      eval "region_highlight+=(\"\${${cache_place}[@]}\")"

    done

  } always {
    _ZSH_HIGHLIGHT_PRIOR_BUFFER=$BUFFER
    _ZSH_HIGHLIGHT_PRIOR_CURSOR=$CURSOR
    return $ret
  }
}


# -------------------------------------------------------------------------------------------------
# API/utility functions for highlighters
# -------------------------------------------------------------------------------------------------

# Array used by highlighters to declare user overridable styles.
typeset -gA ZSH_HIGHLIGHT_STYLES

# Whether the command line buffer has been modified or not.
#
# Returns 0 if the buffer has changed since _zsh_highlight was last called.
_zsh_highlight_buffer_modified()
{
  [[ "${_ZSH_HIGHLIGHT_PRIOR_BUFFER:-}" != "$BUFFER" ]]
}

# Whether the cursor has moved or not.
#
# Returns 0 if the cursor has moved since _zsh_highlight was last called.
_zsh_highlight_cursor_moved()
{
  [[ -n $CURSOR ]] && [[ -n ${_ZSH_HIGHLIGHT_PRIOR_CURSOR-} ]] && (($_ZSH_HIGHLIGHT_PRIOR_CURSOR != $CURSOR))
}


# -------------------------------------------------------------------------------------------------
# Setup functions
# -------------------------------------------------------------------------------------------------

# Rebind all ZLE widgets to make them invoke _zsh_highlights.
_zsh_highlight_bind_widgets()
{
  # Load ZSH module zsh/zleparameter, needed to override user defined widgets.
  zmodload zsh/zleparameter 2>/dev/null || {
    echo 'zsh-syntax-highlighting: failed loading zsh/zleparameter.' >&2
    return 1
  }

  # Override ZLE widgets to make them invoke _zsh_highlight.
  local cur_widget
  for cur_widget in ${${(f)"$(builtin zle -la)"}:#(.*|_*|orig-*|run-help|which-command|beep|yank*)}; do
    case $widgets[$cur_widget] in

      # Already rebound event: do nothing.
      user:$cur_widget|user:_zsh_highlight_widget_*);;

      # User defined widget: override and rebind old one with prefix "orig-".
      user:*) eval "zle -N orig-$cur_widget ${widgets[$cur_widget]#*:}; \
                    _zsh_highlight_widget_$cur_widget() { builtin zle orig-$cur_widget -- \"\$@\" && _zsh_highlight }; \
                    zle -N $cur_widget _zsh_highlight_widget_$cur_widget";;

      # Completion widget: override and rebind old one with prefix "orig-".
      completion:*) eval "zle -C orig-$cur_widget ${${widgets[$cur_widget]#*:}/:/ }; \
                          _zsh_highlight_widget_$cur_widget() { builtin zle orig-$cur_widget -- \"\$@\" && _zsh_highlight }; \
                          zle -N $cur_widget _zsh_highlight_widget_$cur_widget";;

      # Builtin widget: override and make it call the builtin ".widget".
      builtin) eval "_zsh_highlight_widget_$cur_widget() { builtin zle .$cur_widget -- \"\$@\" && _zsh_highlight }; \
                     zle -N $cur_widget _zsh_highlight_widget_$cur_widget";;

      # Default: unhandled case.
      *) echo "zsh-syntax-highlighting: unhandled ZLE widget '$cur_widget'" >&2 ;;
    esac
  done
}

# Load highlighters from directory.
#
# Arguments:
#   1) Path to the highlighters directory.
_zsh_highlight_load_highlighters()
{
  # Check the directory exists.
  [[ -d "$1" ]] || {
    echo "zsh-syntax-highlighting: highlighters directory '$1' not found." >&2
    return 1
  }

  # Load highlighters from highlighters directory and check they define required functions.
  local highlighter highlighter_dir
  for highlighter_dir ($1/*/); do
    highlighter="${highlighter_dir:t}"
    [[ -f "$highlighter_dir/${highlighter}-highlighter.zsh" ]] && {
      . "$highlighter_dir/${highlighter}-highlighter.zsh"
      type "_zsh_highlight_${highlighter}_highlighter" &> /dev/null &&
      type "_zsh_highlight_${highlighter}_highlighter_predicate" &> /dev/null || {
        echo "zsh-syntax-highlighting: '${highlighter}' highlighter should define both required functions '_zsh_highlight_${highlighter}_highlighter' and '_zsh_highlight_${highlighter}_highlighter_predicate' in '${highlighter_dir}/${highlighter}-highlighter.zsh'." >&2
      }
    }
  done
}


# -------------------------------------------------------------------------------------------------
# Setup
# -------------------------------------------------------------------------------------------------

# Try binding widgets.
_zsh_highlight_bind_widgets || {
  echo 'zsh-syntax-highlighting: failed binding ZLE widgets, exiting.' >&2
  return 1
}

# Reset scratch variables when commandline is done.
_zsh_highlight_preexec_hook()
{
  _ZSH_HIGHLIGHT_PRIOR_BUFFER=
  _ZSH_HIGHLIGHT_PRIOR_CURSOR=
}
autoload -U add-zsh-hook
add-zsh-hook preexec _zsh_highlight_preexec_hook 2>/dev/null || {
    echo 'zsh-syntax-highlighting: failed loading add-zsh-hook.' >&2
  }

# Initialize the array of active highlighters if needed.
[[ $#ZSH_HIGHLIGHT_HIGHLIGHTERS -eq 0 ]] && ZSH_HIGHLIGHT_HIGHLIGHTERS=(main) || true

## brackets-highlighter.zsh
# Define default styles.
: ${ZSH_HIGHLIGHT_STYLES[bracket-error]:=fg=red,bold}
: ${ZSH_HIGHLIGHT_STYLES[bracket-level-1]:=fg=blue,bold}
: ${ZSH_HIGHLIGHT_STYLES[bracket-level-2]:=fg=green,bold}
: ${ZSH_HIGHLIGHT_STYLES[bracket-level-3]:=fg=magenta,bold}
: ${ZSH_HIGHLIGHT_STYLES[bracket-level-4]:=fg=yellow,bold}
: ${ZSH_HIGHLIGHT_STYLES[bracket-level-5]:=fg=cyan,bold}
: ${ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]:=standout}

# Whether the brackets highlighter should be called or not.
_zsh_highlight_brackets_highlighter_predicate()
{
  _zsh_highlight_cursor_moved || _zsh_highlight_buffer_modified
}

# Brackets highlighting function.
_zsh_highlight_brackets_highlighter()
{
  local level=0 pos
  local -A levelpos lastoflevel matching typepos
  region_highlight=()

  # Find all brackets and remember which one is matching
  for (( pos = 0; $pos < ${#BUFFER}; pos++ )) ; do
    local char="$BUFFER[pos+1]"
    case $char in
      ["([{"])
        levelpos[$pos]=$((++level))
        lastoflevel[$level]=$pos
        _zsh_highlight_brackets_highlighter_brackettype "$char"
        ;;
      [")]}"])
        matching[$lastoflevel[$level]]=$pos
        matching[$pos]=$lastoflevel[$level]
        levelpos[$pos]=$((level--))
        _zsh_highlight_brackets_highlighter_brackettype "$char"
        ;;
      ['"'\'])
        # Skip everything inside quotes
        local quotetype=$char
        while (( $pos < ${#BUFFER} )) ; do
          (( pos++ ))
          [[ $BUFFER[$pos+1] == $quotetype ]] && break
        done
        ;;
    esac
  done

  # Now highlight all found brackets
  for pos in ${(k)levelpos}; do
    if [[ -n $matching[$pos] ]] && [[ $typepos[$pos] == $typepos[$matching[$pos]] ]]; then
      local bracket_color_size=${#ZSH_HIGHLIGHT_STYLES[(I)bracket-level-*]}
      local bracket_color_level=bracket-level-$(( (levelpos[$pos] - 1) % bracket_color_size + 1 ))
      local style=$ZSH_HIGHLIGHT_STYLES[$bracket_color_level]
      region_highlight+=("$pos $((pos + 1)) $style")
    else
      local style=$ZSH_HIGHLIGHT_STYLES[bracket-error]
      region_highlight+=("$pos $((pos + 1)) $style")
    fi
  done

  # If cursor is on a bracket, then highlight corresponding bracket, if any
  pos=$CURSOR
  if [[ -n $levelpos[$pos] ]] && [[ -n $matching[$pos] ]]; then
    local otherpos=$matching[$pos]
    local style=$ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]
    region_highlight+=("$otherpos $((otherpos + 1)) $style")
  fi
}

# Helper function to differentiate type 
_zsh_highlight_brackets_highlighter_brackettype()
{
  case $1 in
    ["()"]) typepos[$pos]=round;;
    ["[]"]) typepos[$pos]=bracket;;
    ["{}"]) typepos[$pos]=curly;;
    *) ;;
  esac
}

## cursor-highlighter.zsh
# Define default styles.
: ${ZSH_HIGHLIGHT_STYLES[cursor]:=standout}

# Whether the cursor highlighter should be called or not.
_zsh_highlight_cursor_highlighter_predicate()
{
  _zsh_highlight_cursor_moved
}

# Cursor highlighting function.
_zsh_highlight_cursor_highlighter()
{
  region_highlight+=("$CURSOR $(( $CURSOR + 1 )) $ZSH_HIGHLIGHT_STYLES[cursor]")
}

## line-highlighter.zsh
# Define default styles.
: ${ZSH_HIGHLIGHT_STYLES[line]:=}

# Whether the root highlighter should be called or not.
_zsh_highlight_line_highlighter_predicate()
{
  _zsh_highlight_buffer_modified
}

# root highlighting function.
_zsh_highlight_line_highlighter()
{
  region_highlight+=("0 $#BUFFER $ZSH_HIGHLIGHT_STYLES[line]")
}

## main-highlighter.zsh
# Define default styles.
: ${ZSH_HIGHLIGHT_STYLES[default]:=none}
: ${ZSH_HIGHLIGHT_STYLES[unknown-token]:=fg=red,bold}
: ${ZSH_HIGHLIGHT_STYLES[reserved-word]:=fg=yellow}
: ${ZSH_HIGHLIGHT_STYLES[alias]:=fg=green}
: ${ZSH_HIGHLIGHT_STYLES[builtin]:=fg=green}
: ${ZSH_HIGHLIGHT_STYLES[function]:=fg=green}
: ${ZSH_HIGHLIGHT_STYLES[command]:=fg=green}
: ${ZSH_HIGHLIGHT_STYLES[precommand]:=fg=green,underline}
: ${ZSH_HIGHLIGHT_STYLES[commandseparator]:=none}
: ${ZSH_HIGHLIGHT_STYLES[hashed-command]:=fg=green}
: ${ZSH_HIGHLIGHT_STYLES[path]:=underline}
: ${ZSH_HIGHLIGHT_STYLES[path_prefix]:=underline}
: ${ZSH_HIGHLIGHT_STYLES[path_approx]:=fg=yellow,underline}
: ${ZSH_HIGHLIGHT_STYLES[globbing]:=fg=blue}
: ${ZSH_HIGHLIGHT_STYLES[history-expansion]:=fg=blue}
: ${ZSH_HIGHLIGHT_STYLES[single-hyphen-option]:=none}
: ${ZSH_HIGHLIGHT_STYLES[double-hyphen-option]:=none}
: ${ZSH_HIGHLIGHT_STYLES[back-quoted-argument]:=none}
: ${ZSH_HIGHLIGHT_STYLES[single-quoted-argument]:=fg=yellow}
: ${ZSH_HIGHLIGHT_STYLES[double-quoted-argument]:=fg=yellow}
: ${ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]:=fg=cyan}
: ${ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]:=fg=cyan}
: ${ZSH_HIGHLIGHT_STYLES[assign]:=none}

# Whether the highlighter should be called or not.
_zsh_highlight_main_highlighter_predicate()
{
  _zsh_highlight_buffer_modified
}

# Main syntax highlighting function.
_zsh_highlight_main_highlighter()
{
  emulate -L zsh
  setopt localoptions extendedglob bareglobqual
  local start_pos=0 end_pos highlight_glob=true new_expression=true arg style sudo=false sudo_arg=false
  typeset -a ZSH_HIGHLIGHT_TOKENS_COMMANDSEPARATOR
  typeset -a ZSH_HIGHLIGHT_TOKENS_PRECOMMANDS
  typeset -a ZSH_HIGHLIGHT_TOKENS_FOLLOWED_BY_COMMANDS
  region_highlight=()

  ZSH_HIGHLIGHT_TOKENS_COMMANDSEPARATOR=(
    '|' '||' ';' '&' '&&'
  )
  ZSH_HIGHLIGHT_TOKENS_PRECOMMANDS=(
    'builtin' 'command' 'exec' 'nocorrect' 'noglob'
  )
  # Tokens that are always immediately followed by a command.
  ZSH_HIGHLIGHT_TOKENS_FOLLOWED_BY_COMMANDS=(
    $ZSH_HIGHLIGHT_TOKENS_COMMANDSEPARATOR $ZSH_HIGHLIGHT_TOKENS_PRECOMMANDS
  )

  for arg in ${(z)BUFFER}; do
    local substr_color=0
    local style_override=""
    [[ $start_pos -eq 0 && $arg = 'noglob' ]] && highlight_glob=false
    ((start_pos+=${#BUFFER[$start_pos+1,-1]}-${#${BUFFER[$start_pos+1,-1]##[[:space:]]#}}))
    ((end_pos=$start_pos+${#arg}))
    # Parse the sudo command line
    if $sudo; then
      case "$arg" in
        # Flag that requires an argument
        '-'[Cgprtu]) sudo_arg=true;;
        # This prevents misbehavior with sudo -u -otherargument
        '-'*)        sudo_arg=false;;
        *)           if $sudo_arg; then
                       sudo_arg=false
                     else
                       sudo=false
                       new_expression=true
                     fi
                     ;;
      esac
    fi
    if $new_expression; then
      new_expression=false
     if [[ -n ${(M)ZSH_HIGHLIGHT_TOKENS_PRECOMMANDS:#"$arg"} ]]; then
      style=$ZSH_HIGHLIGHT_STYLES[precommand]
     elif [[ "$arg" = "sudo" ]]; then
      style=$ZSH_HIGHLIGHT_STYLES[precommand]
      sudo=true
     else
      res=$(LC_ALL=C builtin type -w $arg 2>/dev/null)
      case $res in
        *': reserved')  style=$ZSH_HIGHLIGHT_STYLES[reserved-word];;
        *': alias')     style=$ZSH_HIGHLIGHT_STYLES[alias]
                        local aliased_command="${"$(alias -- $arg)"#*=}"
                        [[ -n ${(M)ZSH_HIGHLIGHT_TOKENS_FOLLOWED_BY_COMMANDS:#"$aliased_command"} && -z ${(M)ZSH_HIGHLIGHT_TOKENS_FOLLOWED_BY_COMMANDS:#"$arg"} ]] && ZSH_HIGHLIGHT_TOKENS_FOLLOWED_BY_COMMANDS+=($arg)
                        ;;
        *': builtin')   style=$ZSH_HIGHLIGHT_STYLES[builtin];;
        *': function')  style=$ZSH_HIGHLIGHT_STYLES[function];;
        *': command')   style=$ZSH_HIGHLIGHT_STYLES[command];;
        *': hashed')    style=$ZSH_HIGHLIGHT_STYLES[hashed-command];;
        *)              if _zsh_highlight_main_highlighter_check_assign; then
                          style=$ZSH_HIGHLIGHT_STYLES[assign]
                          new_expression=true
                        elif _zsh_highlight_main_highlighter_check_path; then
                          style=$ZSH_HIGHLIGHT_STYLES[path]
                        elif [[ $arg[0,1] == $histchars[0,1] || $arg[0,1] == $histchars[2,2] ]]; then
                          style=$ZSH_HIGHLIGHT_STYLES[history-expansion]
                        else
                          style=$ZSH_HIGHLIGHT_STYLES[unknown-token]
                        fi
                        ;;
      esac
     fi
    else
      case $arg in
        '--'*)   style=$ZSH_HIGHLIGHT_STYLES[double-hyphen-option];;
        '-'*)    style=$ZSH_HIGHLIGHT_STYLES[single-hyphen-option];;
        "'"*"'") style=$ZSH_HIGHLIGHT_STYLES[single-quoted-argument];;
        '"'*'"') style=$ZSH_HIGHLIGHT_STYLES[double-quoted-argument]
                 region_highlight+=("$start_pos $end_pos $style")
                 _zsh_highlight_main_highlighter_highlight_string
                 substr_color=1
                 ;;
        '`'*'`') style=$ZSH_HIGHLIGHT_STYLES[back-quoted-argument];;
        *"*"*)   $highlight_glob && style=$ZSH_HIGHLIGHT_STYLES[globbing] || style=$ZSH_HIGHLIGHT_STYLES[default];;
        *)       if _zsh_highlight_main_highlighter_check_path; then
                   style=$ZSH_HIGHLIGHT_STYLES[path]
                 elif [[ $arg[0,1] = $histchars[0,1] ]]; then
                   style=$ZSH_HIGHLIGHT_STYLES[history-expansion]
                 elif [[ -n ${(M)ZSH_HIGHLIGHT_TOKENS_COMMANDSEPARATOR:#"$arg"} ]]; then
                   style=$ZSH_HIGHLIGHT_STYLES[commandseparator]
                 else
                   style=$ZSH_HIGHLIGHT_STYLES[default]
                 fi
                 ;;
      esac
    fi
    # if a style_override was set (eg in _zsh_highlight_main_highlighter_check_path), use it
    [[ -n $style_override ]] && style=$ZSH_HIGHLIGHT_STYLES[$style_override]
    [[ $substr_color = 0 ]] && region_highlight+=("$start_pos $end_pos $style")
    [[ -n ${(M)ZSH_HIGHLIGHT_TOKENS_FOLLOWED_BY_COMMANDS:#"$arg"} ]] && new_expression=true
    start_pos=$end_pos
  done
}

# Check if the argument is variable assignment
_zsh_highlight_main_highlighter_check_assign()
{
    setopt localoptions extended_glob
    [[ $arg == [[:alpha:]_][[:alnum:]_]#(|\[*\])=* ]]
}

# Check if the argument is a path.
_zsh_highlight_main_highlighter_check_path()
{
  setopt localoptions nonomatch
  local expanded_path; : ${expanded_path:=${(Q)~arg}}
  [[ -z $expanded_path ]] && return 1
  [[ -e $expanded_path ]] && return 0
  # Search the path in CDPATH
  local cdpath_dir
  for cdpath_dir in $cdpath ; do
    [[ -e "$cdpath_dir/$expanded_path" ]] && return 0
  done
  [[ ! -e ${expanded_path:h} ]] && return 1
  if [[ ${BUFFER[1]} != "-" && ${#BUFFER} == $end_pos ]]; then
    local -a tmp
    # got a path prefix?
    tmp=( ${expanded_path}*(N) )
    (( $#tmp > 0 )) && style_override=path_prefix && return 0
    # or maybe an approximate path?
    tmp=( (#a1)${expanded_path}*(N) )
    (( $#tmp > 0 )) && style_override=path_approx && return 0
  fi
  return 1
}

# Highlight special chars inside double-quoted strings
_zsh_highlight_main_highlighter_highlight_string()
{
  setopt localoptions noksharrays
  local i j k style varflag
  # Starting quote is at 1, so start parsing at offset 2 in the string.
  for (( i = 2 ; i < end_pos - start_pos ; i += 1 )) ; do
    (( j = i + start_pos - 1 ))
    (( k = j + 1 ))
    case "$arg[$i]" in
      '$' ) style=$ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]
            (( varflag = 1))
            ;;
      "\\") style=$ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]
            for (( c = i + 1 ; c < end_pos - start_pos ; c += 1 )); do
              [[ "$arg[$c]" != ([0-9,xX,a-f,A-F]) ]] && break
            done
            AA=$arg[$i+1,$c-1]
            # Matching for HEX and OCT values like \0xA6, \xA6 or \012
            if [[ "$AA" =~ "^(0*(x|X)[0-9,a-f,A-F]{1,2})" || "$AA" =~ "^(0[0-7]{1,3})" ]];then
              (( k += $#MATCH ))
              (( i += $#MATCH ))
            else
              (( k += 1 )) # Color following char too.
              (( i += 1 )) # Skip parsing the escaped char.
            fi
              (( varflag = 0 )) # End of variable
            ;;
      ([^a-zA-Z0-9_]))
            (( varflag = 0 )) # End of variable
            continue
            ;;
      *) [[ $varflag -eq 0 ]] && continue ;;

    esac
    region_highlight+=("$j $k $style")
  done
}

## pattern-highlighter.zsh
# List of keyword and color pairs.
typeset -gA ZSH_HIGHLIGHT_PATTERNS

# Whether the pattern highlighter should be called or not.
_zsh_highlight_pattern_highlighter_predicate()
{
  _zsh_highlight_buffer_modified
}

# Pattern syntax highlighting function.
_zsh_highlight_pattern_highlighter()
{
  setopt localoptions extendedglob
  local pattern
  for pattern in ${(k)ZSH_HIGHLIGHT_PATTERNS}; do
    _zsh_highlight_pattern_highlighter_loop "$BUFFER" "$pattern"
  done
}

_zsh_highlight_pattern_highlighter_loop()
{
  # This does *not* do its job syntactically, sorry.
  local buf="$1" pat="$2"
  local -a match mbegin mend
  if [[ "$buf" == (#b)(*)(${~pat})* ]]; then
    region_highlight+=("$((mbegin[2] - 1)) $mend[2] $ZSH_HIGHLIGHT_PATTERNS[$pat]")
    "$0" "$match[1]" "$pat"; return $?
  fi
}

## root-highlighter.zsh
# Define default styles.
: ${ZSH_HIGHLIGHT_STYLES[root]:=standout}

# Whether the root highlighter should be called or not.
_zsh_highlight_root_highlighter_predicate()
{
  _zsh_highlight_buffer_modified
}

# root highlighting function.
_zsh_highlight_root_highlighter()
{
  if [[ $(command id -u) -eq 0 ]] { region_highlight+=("0 $#BUFFER $ZSH_HIGHLIGHT_STYLES[root]") }
}

## syntax-highlighting.zsh
# Reset scratch variables when commandline is done.
_zsh_highlight_preexec_hook()
{
  _ZSH_HIGHLIGHT_PRIOR_BUFFER=
  _ZSH_HIGHLIGHT_PRIOR_CURSOR=
}
autoload -U add-zsh-hook
add-zsh-hook preexec _zsh_highlight_preexec_hook 2>/dev/null || {
    echo 'zsh-syntax-highlighting: failed loading add-zsh-hook.' >&2
  }

# Initialize the array of active highlighters if needed.
[[ $#ZSH_HIGHLIGHT_HIGHLIGHTERS -eq 0 ]] && ZSH_HIGHLIGHT_HIGHLIGHTERS=(main) || true
