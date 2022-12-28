#!/bin/zsh
# https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/systemadmin/systemadmin.plugin.zsh

function retlog() {
  ezsh_log_entry
  if [[ -z ${1} ]];then
    if [[ -f /var/log/nginx/access.log ]]; then
      ezsh_log_info "Using nGinX access log"
      echo '/var/log/nginx/access.log'
    elif [[ -f /var/log/httpd/access.log ]]; then
      ezsh_log_info "Using RHEL Apache access log"
      echo '/var/log/httpd/access.log'
    elif [[ -f /var/log/apache/access.log ]]; then
      ezsh_log_info "Using Debian Apache access log"
      echo '/var/log/apache/access.log'
    else
      ezsh_log_error "Could not find web server access log, specify its location"
      printf "%s" "Could not find web server access log, specify its location"
      exit 127
    fi
  else
    ezsh_log_success "Access log file"
    echo ${1}
  fi
  ezsh_log_exit
}

ip() {
  ezsh_log_entry
  # gather external ip 4 address
  if [[ "${1}" == "external4" ]] || [[ "${1}" == "external" ]]; then
    curl -s -S -4 https://icanhazip.com
  # gather external ip 6 address
  elif [[ "${1}" == "external6" ]]; then
    curl -s -S -6 https://icanhazip.com
  # determine local IP address(es)
  elif [[ "${1}" == "internal" ]]; then
    if (( ${+commands[ip]} )); then
      ip addr | awk '/inet /{print $2}' | command grep -v 127.0.0.1
    else
      ifconfig | awk '/inet /{print $2}' | command grep -v 127.0.0.1
    fi
  else
    if [ -t 1 ]; then
      command ip -c "$@"
    else
      command ip "$@"
    fi
  fi
  ezsh_log_exit
}

# Sort connection state
connections() {
  ezsh_log_entry
  local ezsh_conn_count
  if [[ ${1} == "80" ]]; then
    # View all 80 Port Connections
    netstat -nat|grep -i ":80"|wc -l
  elif [[ ${1} == "404" ]]; then
    # Statistical connections 404
    awk '($9 ~/404/)' "$(retlog[@])" | awk '{print $9,$7}' | sort
  elif [[ ${1} == "ip" ]]; then
    # On the connected IP sorted by the number of connections
    netstat -ntu | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -n
  elif [[ ${1} == "req" ]]; then
    # top20 of Find the number of requests on 80 port
    if [[ "${2}" == "" ]]; then
      ezsh_conn_count=20
    else
      ezsh_conn_count=${2}
    fi
    netstat -anlp|grep 80|grep tcp|awk '{print $5}'|awk -F: '{print $1}'|sort|uniq -c|sort -nr|head -n ${ezsh_conn_count}
  elif [[ ${1} == "tcp4" ]]; then
    # top20 of Using tcpdump ip 4 port 80 access to view
    if [[ "${2}" == "" ]]; then
      ezsh_conn_count=20
    else
      ezsh_conn_count=${2}
    fi
    curl -s -S -4 https://icanhazip.com
    sudo tcpdump -i eth0 -tnn dst port 80 -c 1000 | awk -F"." '{print $1"."$2"."$3"."$4}' | sort | uniq -c | sort -nr |head -n ${ezsh_conn_count}
  elif [[ ${1} == "tcp6" ]]; then
    # top20 of Using tcpdump ip 6 port 80 access to view
    if [[ "${2}" == "" ]]; then
      ezsh_conn_count=20
    else
      ezsh_conn_count=${2}
    fi
    curl -s -S -6 https://icanhazip.com
    sudo tcpdump -i eth0 -tnn dst port 80 -c 1000 | awk -F"." '{print $1"."$2"."$3"."$4}' | sort | uniq -c | sort -nr |head -n ${ezsh_conn_count}
  elif [[ ${1} == "wait" ]]; then
    # top20 of Find time_wait connection
    if [[ "${2}" == "" ]]; then
      ezsh_conn_count=20
    else
      ezsh_conn_count=${2}
    fi
    netstat -n|grep TIME_WAIT|awk '{print $5}'|sort|uniq -c|sort -rn|head -n ${ezsh_conn_count}
  elif [[ ${1} == "syn" ]]; then
    # top20 of Find SYN connection
    if [[ "${2}" == "" ]]; then
      ezsh_conn_count=20
    else
      ezsh_conn_count=${2}
    fi
    netstat -an | grep SYN | awk '{print $5}' | awk -F: '{print $1}' | sort | uniq -c | sort -nr|head -n ${ezsh_conn_count}
  elif [[ ${1} == "proc" ]]; then
    # Printing process according to the port number
    netstat -ntlp | grep "${1:-.}" | awk '{print $7}' | cut -d/ -f1
  elif [[ ${1} == "access" ]]; then
    # top10 of gain access to the ip address
    if [[ "${2}" == "" ]]; then
      ezsh_conn_count=10
    else
      ezsh_conn_count=${2}
    fi
    awk '{counts[$(11)]+=1}; END {for(url in counts) print counts[url], url}' "$(retlog[@])"
  elif [[ ${1} == "visits" ]]; then
    # top20 of Most Visited file or page
    if [[ "${2}" == "" ]]; then
      ezsh_conn_count=20
    else
      ezsh_conn_count=${2}
    fi
    awk '{print $11}' "$(retlog[@])"|sort|uniq -c|sort -nr|head -n ${ezsh_conn_count}
  elif [[ ${1} == "pages" ]]; then
    # top100 of Page lists the most time-consuming (more than 60 seconds) as well as the corresponding page number of occurrences
    if [[ "${2}" == "" ]]; then
      ezsh_conn_count=100
    else
      ezsh_conn_count=${2}
    fi
    awk '($NF > 60 && $7~/\.php/){print $7}' "$(retlog[@])" |sort -n|uniq -c|sort -nr|head -n ${ezsh_conn_count}
  elif [[ ${1} == "traffic" ]]; then
    # Website traffic statistics (G)
    awk "{sum+=$10} END {print sum/1024/1024/1024}" "$(retlog[@])"
  elif [[ ${1} == "status" ]]; then
    # Statistical http status.
    awk '{counts[$(9)]+=1}; END {for(code in counts) print code, counts[code]}' "$(retlog[@])"
  else
    netstat -nat | awk '{print $6}'|sort|uniq -c|sort -rn
  fi
  ezsh_log_exit
}
