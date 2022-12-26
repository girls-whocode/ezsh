#! /bin/zsh

config_read_file() {
  (grep -E "^${2}=" -m 1 "${1}" 2>/dev/null || echo "VAR=__UNDEFINED__") | head -n 1 | cut -d '=' -f 2-;
}

config_get() {
  val="$(config_read_file ${ezsh_script_location}/etc/conf/ezsh.conf "${1}")"

  if [ "${val}" = "__UNDEFINED__" ]; then
      val="$(config_read_file ${ezsh_script_location}/etc/conf/ezsh.conf.defaults "${1}")"
  fi

  printf -- "%s" "${val}"
}

color_config() {
  colors="$(config_read_file ${ezsh_script_location}/etc/conf/colors.conf "${1}")"

  if [ "${val}" = "__UNDEFINED__" ]; then
      val="$(config_read_file ${ezsh_script_location}/etc/conf/colors.conf.defaults "${1}")"
  fi

  printf -- "%s" "${colors}"
}