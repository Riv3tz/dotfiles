# Agnoster with Catppuccin Mocha, with a single-line prompt.
CURRENT_FG='#11111b'
CURRENT_DEFAULT_FG='#cdd6f4'
AGNOSTER_DIR_BG='#89b4fa'
AGNOSTER_DIR_FG='#11111b'
AGNOSTER_CONTEXT_BG='#45475a'
AGNOSTER_CONTEXT_FG='#cdd6f4'
AGNOSTER_GIT_CLEAN_BG='#a6e3a1'
AGNOSTER_GIT_CLEAN_FG='#11111b'
AGNOSTER_GIT_DIRTY_BG='#f9e2af'
AGNOSTER_GIT_DIRTY_FG='#11111b'
AGNOSTER_VENV_BG='#cba6f7'
AGNOSTER_VENV_FG='#11111b'
AGNOSTER_STATUS_BG='#313244'
AGNOSTER_STATUS_FG='#cdd6f4'
AGNOSTER_STATUS_RETVAL_FG='#f38ba8'
AGNOSTER_STATUS_ROOT_FG='#f9e2af'
AGNOSTER_STATUS_JOB_FG='#94e2d5'
AGNOSTER_STATUS_RETVAL_NUMERIC=true
DEFAULT_USER="${DEFAULT_USER:-$USER}"
VIRTUAL_ENV_DISABLE_PROMPT=1
source "$ZSH/themes/agnoster.zsh-theme"

# Capture status and elapsed time without adding external timer processes.
zmodload zsh/datetime
autoload -Uz add-zsh-hook
_agnoster_catppuccin_preexec() {
  _AGNOSTER_COMMAND_START=$EPOCHREALTIME
}
_agnoster_catppuccin_precmd() {
  _AGNOSTER_LAST_STATUS=$?
  _AGNOSTER_DURATION=''
  if [[ -n $_AGNOSTER_COMMAND_START ]]; then
    local elapsed=$(( EPOCHREALTIME - _AGNOSTER_COMMAND_START ))
    if (( elapsed >= 2 )); then
      printf -v _AGNOSTER_DURATION '%.1fs' "$elapsed"
    fi
    unset _AGNOSTER_COMMAND_START
  fi
}
add-zsh-hook preexec _agnoster_catppuccin_preexec
add-zsh-hook precmd _agnoster_catppuccin_precmd

# Starship remains available solely for contextual runtime detection.
# Its Zsh output marks colour escapes as nonprinting for correct line wrapping.
prompt_catppuccin_runtimes() {
  local runtime output=''
  for runtime in nodejs bun python rust golang java php; do
    output+=$(STARSHIP_SHELL=zsh starship module "$runtime" 2>/dev/null)
  done
  if [[ -n $output ]]; then
    print -rn -- " $output"
    CURRENT_BG='NONE'
  fi
}

build_prompt() {
  RETVAL=${_AGNOSTER_LAST_STATUS:-0}
  CURRENT_BG='NONE'
  prompt_status
  prompt_virtualenv
  prompt_aws
  prompt_context
  prompt_dir
  prompt_git
  prompt_end
  CURRENT_BG='NONE'
  prompt_catppuccin_runtimes
  [[ -n $_AGNOSTER_DURATION ]] && print -rn -- " %F{#f9e2af}󱎫 $_AGNOSTER_DURATION%f"
  print -rn -- " "
  if (( RETVAL )); then
    print -rn -- "%F{#f38ba8}❯%f"
  else
    print -rn -- "%F{#a6e3a1}❯%f"
  fi
}
PROMPT='%{%f%b%k%}$(build_prompt) '
