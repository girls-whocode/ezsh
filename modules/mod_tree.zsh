#!/bin/zsh

# https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/systemadmin/systemadmin.plugin.zsh
tree() {
  ezsh_log_entry
  find $@ -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'
  ezsh_log_exit
}
