#! /bin/zsh
# The timer has minor error checking but is not agile enough to detect all errors.
# It will detect if the timer stops without a start, completes without an end, and
# end was placed before the start. This plugin uses the logging plugin to output
# any errors or completions into the log file.
#
# The timer take 3 arguments:
#     start - use this to start the timer
#     stop - use this to stop the timer
#     complete - use this to return the number of secods from start to stop
#
# To use the timer:
#
# ezsh_timer start
#    ... Enter your code here ...
# ezsh_timer stop
# ezsh_timer complete
#
# if [[ ${ezsh_timer_message} == "" ]]; then
#   echo "Your script completed in ${ezsh_timer_complete} seconds."
# else
#   echo "Timer error: ${ezsh_timer_message}"
#   unset ezsh_timer_message
# fi

ezsh_timer() {
  ezsh_log_entry
  if [[ "${1}" == "start" ]]; then
    ezsh_timer_start=$(date +%s.%3N)
    ezsh_timer_return=${ezsh_timer_start}
    ezsh_log_info "Timer started at ${ezsh_timer_return}"
    return ${ezsh_timer_return}

  elif [[ "${1}" == "stop" ]]; then
    ezsh_timer_end=$(date  +%s.%3N)
    ezsh_timer_return=${ezsh_timer_end}
    ezsh_log_info "Timer stopped at ${ezsh_timer_return}"

  elif [[ "${1}" == "complete" ]]; then
    if [[ ${ezsh_timer_end} -gt 0 ]] && [[ ${ezsh_timer_start} -gt 0 ]]; then
      ezsh_timer_complete=$(echo "scale=0; ${ezsh_timer_end} - ${ezsh_timer_start}" | bc)

      if [[ ${ezsh_timer_complete} -gt 0 ]]; then
        ezsh_timer_return=${ezsh_timer_complete}
        ezsh_log_success "Timer completed at ${ezsh_timer_return}"
        unset ezsh_timer_start ezsh_timer_end ezsh_timer_complete
      else
        ezsh_timer_message="The timer stopped before it started"
        ezsh_log_error "${ezsh_timer_message}"
        unset ezsh_timer_start ezsh_timer_end ezsh_timer_complete
      fi
    elif [[ ${ezsh_timer_start} -eq 0 ]]; then
      ezsh_timer_message="The timer was never started"
      ezsh_log_error "${ezsh_timer_message}"
      unset ezsh_timer_start ezsh_timer_end ezsh_timer_complete

    elif [[ ${ezsh_timer_end} -eq 0 ]]; then
      ezsh_timer_message="The timer was never stopped"
      ezsh_log_error "${ezsh_timer_message}"
      unset ezsh_timer_start ezsh_timer_end ezsh_timer_complete
    fi

  else
    ezsh_timer_message="Timer function ${1} is not valid"
    ezsh_log_error "${ezsh_timer_message}"
    unset ezsh_timer_start ezsh_timer_end ezsh_timer_complete
  fi
}