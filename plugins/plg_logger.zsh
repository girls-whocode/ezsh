#!/bin/zsh
# https://github.com/jeliasson/zsh-logging
 
# Script log
SCRIPT_LOG_PATH="${ezsh_script_location}/$(config_get ezsh_log_path)"
SCRIPT_LOG_FILE="$(config_get ezsh_log_file)"

# Scripts log
SCRIPT_LOG=${SCRIPT_LOG_PATH}/${SCRIPT_LOG_FILE}

# Make directory and log file
[[ ! -d "${SCRIPT_LOG_PATH}" ]] || mkdir -p "${SCRIPT_LOG_PATH}"
[[ ! -f "${SCRIPT_LOG_PATH}/${SCRIPT_LOG_FILE}" ]] || touch ${SCRIPT_LOG_PATH}/${SCRIPT_LOG_FILE}

ezsh_log_start() {
  SCRIPT_NAME=$(basename "$0")
  SCRIPT_NAME="${SCRIPT_NAME%.*}"
  echo -e "\e[1;30;40m[$(date)]\e[0m \e[0;35;40m[DEBUG]\e[0m \e[1;30;40m> $SCRIPT_NAME ${funcstack[0]}\e[0m" >> "$SCRIPT_LOG"
}

ezsh_log_stop() {
  SCRIPT_NAME=$(basename "$0")
  SCRIPT_NAME="${SCRIPT_NAME%.*}"
  echo -e "\e[1;30;40m[$(date)]\e[0m \e[0;35;40m[DEBUG]\e[0m \e[1;30;40m< $SCRIPT_NAME ${funcstack[0]}\e[0m" >> "$SCRIPT_LOG"
}

ezsh_log_entry() {
  echo -e "\e[1;30;40m[$(date)]\e[0m \e[0;35;40m[DEBUG]\e[0m \e[1;30;40m> ${funcstack[2]}\e[0m" >> "$SCRIPT_LOG"
}

ezsh_log_exit() {
  echo -e "\e[1;30;40m[$(date)]\e[0m \e[0;35;40m[DEBUG]\e[0m \e[1;30;40m< ${funcstack[2]}\e[0m" >> "$SCRIPT_LOG"
}

ezsh_log_info() {
  local function_name="${FUNCNAME[1]}"
  local msg="${1}"
  
  echo -e "\e[1;30;40m[$(date)]\e[0m \e[0;34;40m[INFO]\e[0m    $msg" >> "$SCRIPT_LOG"
}

ezsh_log_success() {
  local function_name="${FUNCNAME[1]}"
  local msg="${1}"
  
  echo -e "\e[1;30;40m[$(date)]\e[0m \e[3;32;40m[SUCCESS]\e[0m $msg" >> "$SCRIPT_LOG"
}

ezsh_log_warn() {
  local function_name="${FUNCNAME[1]}"
  local msg="${1}"
  
  echo -e "\e[1;30;40m[$(date)]\e[0m \e[0;33;40m[WARN]\e[0m    $msg" >> "$SCRIPT_LOG"
}

ezsh_log_debug() {
  local function_name="${FUNCNAME[1]}"
  local msg="${1}"
  
  echo -e "\e[1;30;40m[$(date)]\e[0m \e[0;35;40m[DEBUG]\e[0m   $msg" >> "$SCRIPT_LOG"
}

ezsh_log_error() {
  local function_name="${FUNCNAME[1]}"
  local msg="${1}"
  
  echo -e "\e[1;30;40m[$(date)]\e[0m \e[0;31;40m[ERROR]\e[0m   $msg" >> "$SCRIPT_LOG"
}

export ezsh_log_start
export ezsh_log_stop
export ezsh_log_entry
export ezsh_log_exit
export ezsh_log_info
export ezsh_log_success
export ezsh_log_warn
export ezsh_log_debug
export ezsh_log_error