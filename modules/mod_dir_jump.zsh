#!/bin/zsh

ezsh_directory_list="${ezsh_script_location}/$(config_get ezsh_dir_jump_folder)/$(config_get ezsh_dir_list_file)"
ezsh_last_dir_remove="${ezsh_script_location}/$(config_get ezsh_dir_jump_folder)/$(config_get ezsh_dir_last_removed)"
ezsh_dir_jump_command="$(config_get ezsh_dir_jump_command)"
ezsh_dir_hist_size=$(config_get ezsh_dir_jump_hist_size)

# Check to see if the directories and files exist, if they don't create them
[ ! -d "$(config_get ezsh_dir_jump_folder)" ] && mkdir -p "${ezsh_script_location}/$(config_get ezsh_dir_jump_folder)"
[ ! -f "${ezsh_directory_list}" ] && touch "${ezsh_directory_list}"

alias "${ezsh_dir_jump_command}"=ezsh_dirjump
alias "up"="ezsh_dir_jump_up"
alias 0="cd ~"

ezsh_dir_list=0
while [ ${ezsh_dir_list} -le "${ezsh_dir_hist_size}" ]; do
	alias ${ezsh_dir_list}="${ezsh_dir_jump_command} ${ezsh_dir_list}"
	ezsh_dir_list=$((1 + ezsh_dir_list))
done

ezsh_dir_jump_last_del() {
  ezsh_log_entry
	ezsh_dir_jump_time_del=$(cat "${ezsh_last_dir_remove}")
	ezsh_dir_jump_curr_time=$(date +%s)
	ezsh_dir_jump_delta_hour=$(echo "(${ezsh_dir_jump_curr_time}-${ezsh_dir_jump_time_del})/3600" | bc)

	if [ "${ezsh_dir_jump_delta_hour}" -ge 1 ]; then
		if [ "${ezsh_dir_jump_delta_hour}" -eq 1 ]; then
      ezsh_log_info "A path was last removed an hour ago."
			# echo "A path was last removed an hour ago."
		else
      ezsh_log_info "A path was last removed ${ezsh_dir_jump_delta_hour} hours ago."
			# echo "A path was last removed ${ezsh_dir_jump_delta_hour} hours ago."
		fi
	else
		ezsh_dir_jump_delta_minute=$(echo "(${ezsh_dir_jump_curr_time}-${ezsh_dir_jump_time_del})/60" | bc)
		if [ "${ezsh_dir_jump_delta_minute}" -eq 0 ]; then
			ezsh_log_info "A path was last removed just now."
      # echo "A path was last removed just now."
		elif [ "${ezsh_dir_jump_delta_minute}" -eq 1 ]; then
			ezsh_log_info "A path was last removed a minute ago."
      # echo "A path was last removed a minute ago."
		else
      ezsh_log_info "A path was last removed ${ezsh_dir_jump_delta_minute} minutes ago."
			# echo "A path was last removed ${ezsh_dir_jump_delta_minute} minutes ago."
		fi
	fi
  ezsh_log_exit
}

ezsh_dir_jump_get_nth_path() {
  ezsh_log_entry
	# Get dir path of nth line of ezsh_directory_list
	# Source: https://stackoverflow.com/a/27056916/9157799
	if [[ "${1}" == 0 ]]; then
		echo "${HOME}"
	else
		echo "$(awk -v line=${1} 'NR==line' "${ezsh_directory_list}")"
	fi
  ezsh_log_exit
}

ezsh_dir_jump_apply_max_limit_to_history() {
  ezsh_log_entry
	# delete all directories whose numbers exceed the specified limit
	# Source: https://stackoverflow.com/q/45125826/9157799

	head -"${ezsh_dir_hist_size}" "${ezsh_directory_list}" > "$(config_get ezsh_dir_jump_folder)"/temp;
	mv -f "$(config_get ezsh_dir_jump_folder)"/temp "${ezsh_directory_list}"
  ezsh_log_exit
}

ezsh_dir_jump_insert_dir_path_to_top() {
  ezsh_log_entry
	# Source: https://superuser.com/a/246841/943615
	echo "${1}" | cat - "${ezsh_directory_list}" > "$(config_get ezsh_dir_jump_folder)/temp" && mv -f "$(config_get ezsh_dir_jump_folder)/temp" "${ezsh_directory_list}"
  ezsh_log_exit
}

ezsh_dir_jump_number_of_dir_paths() {
  ezsh_log_entry
	# Source: https://stackoverflow.com/a/12022403/9157799
	wc -l < "${ezsh_directory_list}"
  ezsh_log_exit
}

ezsh_dir_jump_print_directory_history() {
  ezsh_log_entry
	echo -e "${Aqua}Use the number to jump to that directory${txtReset}\n"
	echo -e "${Aqua} 0 ${Yellow} ${HOME} ${txtReset}"
	while read items; do
		local count
		((count++))
		echo -e "${Aqua} ${count} ${Yellow} ${items} ${txtReset}"
	done < "${ezsh_directory_list}"
  ezsh_log_exit
}

ezsh_dir_jump_path_already_listed() {
  ezsh_log_entry
	# Check if the given path already listed
	# Source: https://stackoverflow.com/a/4749368/9157799

	if grep -Fxq "$1" "${ezsh_directory_list}"; then
		echo "exist"
	else
		echo "notexist"
	fi
  ezsh_log_exit
}

ezsh_dirjump() {
  ezsh_log_entry
	# if the number of argument is greater than 1
	if [ $# -gt 1 ]; then
		echo "usage: ${dirjump_command} [dir path number]"
		return
	fi

	# if no argument is given
	if [ $# -eq 0 ]; then
		ezsh_dir_jump_delete_paths_that_no_longer_exist
		ezsh_dir_jump_print_directory_history

		if [ -f "${ezsh_last_dir_remove}" ]; then
			last_del
		fi

		return
	fi

	# if the requested path number is not out of range
	if [[ $1 -le $(ezsh_dir_jump_number_of_dir_paths) ]] && [[ $1 -ge 0 ]]; then
		cd "$(ezsh_dir_jump_get_nth_path $1)"
	else
		echo "dirjump: the requested dir path number is out of range"
	fi
  ezsh_log_exit
}

ezsh_dir_jump_delete_a_dir_path() {
  ezsh_log_entry
	# Source: https://stackoverflow.com/a/5413132/9157799
	grep -Fxv "$1" "${ezsh_directory_list}" > "$(config_get ezsh_dir_jump_folder)"/temp; mv -f "$(config_get ezsh_dir_jump_folder)/"/temp "${ezsh_directory_list}"
  ezsh_log_exit
}

ezsh_dir_jump_delete_paths_that_no_longer_exist() {
  ezsh_log_entry
	# iterate $ezsh_directory_list
	while IFS="" read -r p || [ -n "$p" ]; do
		if [[ ! -d $p ]]; then
			# if the dir doesn't exists, it's deleted from $ezsh_directory_list
			
      printf '%s\n' "Deleting \"$p\" from ezsh_directory_list"
			sed -i "\?^$p\$?d" $ezsh_directory_list
		fi
	done < $ezsh_directory_list
}

ezsh_dir_jump_propose_dir_path() {
  ezsh_log_entry
	# if it is home directory, reject the proposal
	if [[ "$PWD" == "$HOME" ]]; then
		return
	fi

	if [[ "$(ezsh_dir_jump_path_already_listed "$PWD")" == "exist" ]]; then
		ezsh_dir_jump_delete_a_dir_path "$PWD"
	fi

	ezsh_dir_jump_insert_dir_path_to_top "$PWD"
	if [[ $(ezsh_dir_jump_number_of_dir_paths) -gt "${ezsh_dir_hist_size}" ]]; then
		ezsh_dir_jump_apply_max_limit_to_history
		date +%s > "${ezsh_last_dir_remove}"
	fi
  ezsh_log_exit
}

ezsh_dir_jump_up() {
  ezsh_log_entry
  local d=""
  limit=$1

	for ((i=1 ; i <= limit ; i++)); do
		d=$d/..
	done

	d=$(echo $d | sed 's/^\///')

	if [ -z "$d" ]; then
		d=..
	fi

	cd $d
  ezsh_log_exit
}

# Source: https://stackoverflow.com/a/3964198/9157799
chpwd_functions=(${chpwd_functions[@]} ezsh_dir_jump_propose_dir_path)