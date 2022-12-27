#!/bin/zsh

empty() {
	if [ -f "${1}" ];then
		cat /dev/null >"${1}"
	else
		touch "${1}"
	fi
}