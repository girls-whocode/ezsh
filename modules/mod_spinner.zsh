#!/bin/zsh
# title					:Enhanced BASH v3
# description			:To be used within scripts to create a spinner
# author				:Jessica Brown
# date					:2022-11-19
# version				:1.0.0
# usage					:start_spinner "Message" ... stop_spinner
# notes					:
# bash_version	:5.1.16(1)-release
# ==============================================================================

start_spinner() {
    ezsh_log_entry
    tput civis
    set +m
    echo -ne "$1            "
    while : ;do 
        for X in " ▐⠂       ▌ " " ▐⠈       ▌ " " ▐ ⠂      ▌ " " ▐ ⠠      ▌ " " ▐  ⡀     ▌ " " ▐  ⠠     ▌ " " ▐   ⠂    ▌ " " ▐   ⠈    ▌ " " ▐    ⠂   ▌ " " ▐    ⠠   ▌ " " ▐     ⡀  ▌ " " ▐     ⠠  ▌ " " ▐      ⠂ ▌ " " ▐      ⠈ ▌ " " ▐       ⠂▌ " " ▐       ⠠▌ " " ▐       ⡀▌ " " ▐      ⠠ ▌ " " ▐      ⠂ ▌ " " ▐     ⠈  ▌ " " ▐     ⠂  ▌ " " ▐    ⠠   ▌ " " ▐    ⡀   ▌ " " ▐   ⠠    ▌ " " ▐   ⠂    ▌ " " ▐  ⠈     ▌ " " ▐  ⠂     ▌ " " ▐ ⠠      ▌ " " ▐ ⡀      ▌ " " ▐⠠       ▌ "; do 
            echo -en "\b\b\b\b\b\b\b\b\b\b\b\b$X"
            sleep 0.1
        done
    done & true>/dev/null
    ezsh_spinner_pid=$!
    ezsh_log_success "Spinner created with PID ${ezsh_spinner_pid}"
    ezsh_log_exit
}

stop_spinner() {
    ezsh_log_entry
    { kill -9 "${ezsh_spinner_pid}" && wait; } 2>/dev/null
    ezsh_log_success "Spinner stopped with PID ${ezsh_spinner_pid}"
    tput cnorm
    set -m
    echo -en "\033[2K\r"
    ezsh_log_exit
}