#!/bin/zsh

function setPattern() {
  ezsh_log_entry
  compName=$(hostname)
  standardPattern='
    s/\[/\e[1;33m$&\e[0;36m/g;
    s/\]/\e[1;33m$&\e[0;36m/g;
    s/\(.*?\)/\e[0;33m$&\e[0m/g;
    s/\".*?\"/\e[0;43m$&\e[0m/g;
    s/'"'"'.*?'"'"'/\e[1;34m$&\e[0m/g;
    s/'${compName}'/\e[1;32m$&\e[0m/g;
    s/[0-9]{4}-[0-9]{2}-[0-9]{2}/\e[1;94m$&\e[0m/g;
    s/[0-9]{2}-[0-9]{2}-[0-9]{4}/\e[1;94m$&\e[0m/g;
    s/(Sun|Mon|Tue|Wed|Thu|Fri|Sat)\s[0-9]{2}\s(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\s[0-9]{4}\s/\e[1;94m$&\e[0m/gi;
    s/[0-9]{2}:[0-9]{2}:[0-9]{2}\-[0-9]{4}/\e[1;94m$&\e[0m/g;
    s/[0-9]{2}:[0-9]{2}:[0-9]{2}/\e[1;94m$&\e[0m/g;
    s/(DEBUG|DBG|DEBUG1|DEBUG2|DEBUG3)/\e[1;30m$&\e[0m/gi;
    s/INFO/\e[1;36m$&\e[0m/gi;
    s/(ERROR|ERR)/\e[1;31m$&\e[0m/gi;
    s/(WARNING|WARN)/\e[1;93m$&\e[0m/gi;
    s/SEVERE/\e[1;31m$&\e[0m/gi;
    s/CMD/\e[0;43m$&\e[0m/gi;
    s/LIST/\e[1;45m$&\e[0m/gi;
    s/-{3,}/\e[1;32m$&\e[0m/g;
    s/(?:(?:1?[1-9]?\d|[12][0-4]\d|25[0-5])(?:\.(?!$)|$)){4}$/\e[1;32m$&\e[0m/g;
    s/Reached /\e[1;46m$&\e[0m/g; 
    s/Mounted /\e[1;42m$&\e[0m/g;
    s/Listening /\e[1;45m$&\e[0m/g;
    s/Finished /\e[1;42m$&\e[0m/g;
    s/https?:\/\/(?:www\.)?([-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b)*(\/[\/\d\w\.-]*)*(?:[\?])*(.+)*/\e[1;42m$&\e[0m/g;
  '

  if [ "$1" != "" ]; then
    additionalSearchPattern='s/'$1'/\e[0;30;43m$&\e[0m/g;'
    searchPattern="${standardPattern}${additionalSearchPattern}"
  else
    searchPattern=${standardPattern}
  fi
  ezsh_log_exit
}

function taillog() {
  ezsh_log_entry
  ezsh_log_info "log tailed ${1}"
  setPattern ${2}
  tail -f ${1} | perl -pe "${searchPattern}"
  searchPattern=${standardPattern}
  ezsh_log_exit
}

function viewlog() {
  ezsh_log_entry
  ezsh_log_info "log viewed ${1}"
  setPattern ${2}
  cat ${1} | perl -pe "${searchPattern}"
  searchPattern=${standardPattern}
  ezsh_log_entry
}