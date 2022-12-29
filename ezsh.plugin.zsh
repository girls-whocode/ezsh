#!/bin/zsh

# Get current working directory
# ezsh_script_location="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ezsh_script_location=${0:h}
bold=$(tput bold)

# Load configuration file
source ${ezsh_script_location}/etc/conf/ezsh_config.zsh

# Load any plugins required
source ${ezsh_script_location}/plugins/plg_strings.zsh
source ${ezsh_script_location}/plugins/plg_logger.zsh
source ${ezsh_script_location}/plugins/plg_timer.zsh
source ${ezsh_script_location}/plugins/plg_errors.zsh

# Main application
main() {
  ezsh_log_entry
  ezsh_timer start

  source ${ezsh_script_location}/modules/mod_spinner.zsh
  source ${ezsh_script_location}/modules/mod_dir_jump.zsh
  source ${ezsh_script_location}/modules/mod_backup.zsh
  source ${ezsh_script_location}/modules/mod_viewer.zsh
  source ${ezsh_script_location}/modules/mod_empty.zsh
  source ${ezsh_script_location}/modules/mod_tree.zsh
  source ${ezsh_script_location}/modules/mod_network.zsh

  ezsh_timer stop
  ezsh_timer complete

  if [[ ${ezsh_timer_message} == "" ]]; then
    echo "Your script completed in ${ezsh_timer_complete} seconds."
  else
    echo "Timer error: ${ezsh_timer_message}"
    unset ezsh_timer_message
  fi
  ezsh_log_exit
}

exit_trap() {
  tput cnorm
  set -m
  echo -en "\033[2K\r"
  ezsh_log_stop
}

trap exit_trap EXIT

ezsh_log_start
main
