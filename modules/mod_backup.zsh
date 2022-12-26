#!/bin/zsh

function backup() {
    ezsh_back_up_time_stamp=$(LC_ALL=C date +$(config_get ezsh_back_up_time_stamp))

    # Check if it is a directory, if so, then rsync entire directory with timestamp
    if [[ -d "${1}" ]]; then
      ezsh_back_up_source_folder="$(basename "$1")-${ezsh_back_up_time_stamp}"
      
      if [[ ! -d "${ezsh_script_location}/$(config_get ezsh_back_up_folder)" ]]; then
        mkdir -p "${ezsh_script_location}/$(config_get ezsh_back_up_folder)"
      fi

      rsync -aqr "${1}" "${ezsh_script_location}/$(config_get ezsh_back_up_folder)/${ezsh_back_up_source_folder}"
      printf "Backup of %b%s%b has completed in %b%s%b\n" "$(color_config CadetBlue)" "${1}" "$(color_config txtReset)" "$(color_config Maroon)" "${ezsh_script_location}/$(config_get ezsh_back_up_folder)" "$(color_config txtReset)"

    # Check if it is a file, if so, then copy file with timestamp
    elif [[ -f "${1}" ]]; then
      cp "${1}" "${ezsh_script_location}/$(config_get ezsh_back_up_folder)$(basename "$1")-${ezsh_back_up_time_stamp}"

    # File or directory was not found
    else
      ezsh_log_error "${1} file or directory was not stat"
      printf "%bError%b: %s was not found, please check the name and try again.\n" "$(color_config Red)" "$(color_config txtReset)" "${1}"
    fi
}