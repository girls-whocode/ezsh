#!/bin/zsh

ezsh_trim_string() {
  : "${1#"${1%%[![:space:]]*}"}"
  : "${_%"${_##*[![:space:]]}"}"
  printf '%s\n' "$_"
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

ezsh_split() {
   # Usage: ezsh_split "string" "delimiter"
   IFS=$'\n' read -d "" -rA arr <<< "${1//$2/$'\n'}"
   printf '%s\n' "${arr[@]}"
}

ezsh_reverse_case() {
    # Usage: ezsh_reverse_case "string"
    printf '%s\n' "${1~~}"
}

ezsh_trim_quotes() {
    # Usage: ezsh_trim_quotes "string"
    : "${1//\'}"
    printf '%s\n' "${_//\"}"
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

ezsh_urlencode() {
    # Usage: ezsh_urlencode "string"
    local LC_ALL=C
    for (( i = 0; i < ${#1}; i++ )); do
        : "${1:i:1}"
        case "$_" in
            [a-zA-Z0-9.~_-])
                printf '%s' "$_"
            ;;

            *)
                printf '%%%02X' "'$_"
            ;;
        esac
    done
    printf '\n'
}

ezsh_urldecode() {
    # Usage: ezsh_urldecode "string"
    : "${1//+/ }"
    printf '%b\n' "${_//%/\\x}"
}
