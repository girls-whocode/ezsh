#!/bin/zsh

extract() {
  ezsh_log_entry
  ezsh_archive="$1"
  
  if [[ "$(config_get ezsh_default_target)" == "default" ]]; then
    ezsh_extract_folder=$ezsh_archive:t:r
  else
    ezsh_extract_folder=$(config_get ezsh_default_target)
  fi

  if [[ -f ${ezsh_archive} ]]; then
    ezsh_archive="$(readlink -f "$ezsh_archive")"

    vared -p 'Extract to [default: ${ezsh_extract_folder}]: ' -c ezsh_extract_folder

    if [[ ! -d ${ezsh_extract_folder} ]]; then
      ezsh_log_info "Directory '${ezsh_extract_folder}' does not exist, creating it"
      mkdir -p ${ezsh_extract_folder}
      # printf "%bDirectory Error:%b '%b%s%b' does not exist" "$(color_config Red)" "$(color_config txtReset)" "$(color_config CadetBlue)" "${ezsh_extract_folder}" "$(color_config txtReset)"
    fi

    if [[ ! -w ${ezsh_extract_folder} ]]; then
      ezsh_log_info "Permission denied: '${ezsh_extract_folder}' is not writable"
      printf "%bPermission denied:%b '%b%s%b' is not writable" "$(color_config Red)" "$(color_config txtReset)" "$(color_config CadetBlue)" "${ezsh_extract_folder}" "$(color_config txtReset)"
    fi

    cd "${ezsh_extract_folder}" || return
    case "${ezsh_archive}" in
      *.tar.bz2)   tar xjf "${ezsh_archive}"     ;;
      *.tar.gz)    tar xzf "${ezsh_archive}"     ;;
      *.bz2)       bunzip2 "${ezsh_archive}"     ;;
      *.rar)       unrar e "${ezsh_archive}"     ;;
      *.gz)        gunzip "${ezsh_archive}"      ;;
      *.tar)       tar xf "${ezsh_archive}"      ;;
      *.tbz2)      tar xjf "${ezsh_archive}"     ;;
      *.tgz)       tar xzf "${ezsh_archive}"     ;;
      *.zip)       unzip "${ezsh_archive}"       ;;
      *.Z)         uncompress "${ezsh_archive}"  ;;
      *.7z)        7z x "${ezsh_archive}"        ;;
      *)           printf "'%s' cannot be extracted" "${ezsh_archive}";;
    esac
  else
    ezsh_log_info "'${ezsh_archive}' does not exist"
    printf "%bError:%b '%b%s%b' does not exist" "$(color_config Red)" "$(color_config txtReset)" "$(color_config CadetBlue)" "${ezsh_archive}" "$(color_config txtReset)"
  fi
  ezsh_log_exit
}
