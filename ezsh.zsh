#! /bin/zsh

# Get current working directory
ezsh_script_location="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load configuration file
source ${ezsh_script_location}/etc/conf/ezsh_config.zsh

# Load any plugins required
source ${ezsh_script_location}/plugins/plg_logger.zsh
source ${ezsh_script_location}/plugins/plg_timer.zsh
source ${ezsh_script_location}/plugins/plg_errors.zsh

# Main application
main() {
  ezsh_log_start
  ezsh_log_entry
  ezsh_timer start

  source ${ezsh_script_location}/modules/mod_dir_jump.zsh
  sleep 0.5


  ezsh_timer stop
  ezsh_timer complete

  if [[ ${ezsh_timer_message} == "" ]]; then
    echo "Your script completed in ${ezsh_timer_complete} seconds."
  else
    echo "Timer error: ${ezsh_timer_message}"
    unset ezsh_timer_message
  fi
  ezsh_log_stop
  ezsh_log_exit
}

main