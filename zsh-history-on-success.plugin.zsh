function zshaddhistory() {
  # Removes trailing newline characters from command
  LASTHIST="${1%%$'\n'}"
  # Return value 2: "... the history line will be saved on the internal
  # history list, but not written to the history file".
  return 2
}

# executed after the command has been read and about to be executed
function _custom_preexec() {
  # sets command start time
  cmdStartMs=$(date +%s%3N)
}

# function called to print command to zsh history file
function _print_to_history() {
  # also need to remove newlines here otherwise we will have trailing backslashes written to our history
  print -sr -- "${LASTHIST%%'\n'}"
}

# zsh hook called before the prompt is printed. See man zshmisc(1).
function _custom_precmd() {
  # Get the exit code first so that we can access it in the rest of this function without accidently
  # getting the exit code of any of the commands that we run in this function
  exitCode=$?

  # checks if history file environment variable is set
  if [[ -n "$HISTFILE" ]]; then
    # Write the last command if successful and if the last command is not whitespace characters,
    # using the history buffered by zshaddhistory().
    if [[ $exitCode == 0 && -n "${LASTHIST//[[:space:]\n]/}" ]]; then
      _print_to_history
    fi

    # Write the last command if it exited with a CTRL+C signal and the elapsed time is longer than
    # the filter duration
    if [[ -n "$cmdStartMs" ]]; then
      if [[ ${ZSH_HISTORY_DISABLE_CTRL_C_SAVES:-} != true && $exitCode == 130 ]]; then
        elapsedMs=$(($(date +%s%3N)-$cmdStartMs))

        filterDuration=$((${ZSH_HISTORY_CTRL_C_DURATION_SECONDS:-$((${ZSH_HISTORY_CTRL_C_DURATION_MINUTES:-10} * 60))} * 1000))
        if [[ $elapsedMs -gt $filterDuration ]]; then
          _print_to_history
        fi
      fi
      unset cmdStartMs
    fi
  fi
}

# appends to preexec_functions so we don't overwrite another plugin's preexec function
[[ -z $preexec_functions ]] && preexec_functions=()
preexec_functions=($preexec_functions _custom_preexec)

# appends to precmd_functions so we don't overwrite another plugin's precmd function
[[ -z $precmd_functions ]] && precmd_functions=()
precmd_functions=($precmd_functions _custom_precmd)
