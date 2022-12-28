#!/bin/zsh

ezsh_trim_string() {
  : "${1#"${1%%[![:space:]]*}"}"
  : "${_%"${_##*[![:space:]]}"}"
  printf '%s\n' "$_"
}

ezsh_trim_quotes() {
    # Usage: ezsh_trim_quotes "string"
    : "${1//\'}"
    printf '%s\n' "${_//\"}"
}

ezsh_regex() {
  typeset ec
  unset -v ezsh_regex
  [[ $1 =~ $2 ]]
  ec=$?
  [[ $ec -eq 0 ]] && reMatch=( "$MATCH" "${match[@]}" )

  printf "%s\n" "$reMatch"
}

ezsh_lower() {
  printf '%s\n' "${1:l}"
}

ezsh_upper() {
  printf '%s\n' "${1:u}"
}

ezsh_reverse() {
  len=${#1}
  for ((i=${len}-1; i >= 0; i--)); do
    reverse="${reverse}${1:$i:1}" 
  done
  printf "%s\n" "${reverse}"
}

ezsh_split() {
  # Usage: ezsh_split "string" "delimiter"
  eval $3'=("${(@ps:$2:)$1}")'
  printf "%s" "$3"
}

ezsh_reverse_case() {
    # Usage: ezsh_reverse_case "string"
    printf '%s\n' "${1~~}"
}

ezsh_strip() {
    # Usage: ezsh_strip "string" "pattern"
    printf '%s\n' "${1/$2}"
}

ezsh_strip_all() {
    # Usage: ezsh_strip_all "string" "pattern"
    printf '%s\n' "${1//$2}"
}

ezsh_lstrip() {
    # Usage: ezsh_lstrip "string" "pattern"
    printf '%s\n' "${1##$2}"
}

ezsh_rstrip() {
    # Usage: ezsh_rstrip "string" "pattern"
    printf '%s\n' "${1%%$2}"
}

ezsh_url_encode() {
  setopt localoptions extendedglob
  input=( ${(s::)1} )
  print ${(j::)input/(#b)([^A-Za-z0-9_.\!~*\'\(\)-])/%${(l:2::0:)$(([##16]#match))}}
}

ezsh_urldecode() {
    # Usage: ezsh_urldecode "string"
    : "${1//+/ }"
    printf '%b\n' "${_//%/\\x}"
}
