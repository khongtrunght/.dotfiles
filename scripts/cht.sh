#!/usr/bin/env bash
# languages=$(echo "golang lua cpp c python" | tr ' ' '\n')
# core_utils=$(echo "xargs find mv sed awk" | tr ' ' '\n')
languages=$(cat ~/.config/.tmux-cht-languages)
core_utils=$(cat ~/.config/.tmux-cht-command)

selected=$(printf "$languages\n$core_utils" | fzf)
# read -p "query: " query
#
# if printf $languages | grep -qs $selected; then
# 	tmux neww bash -c "curl cht.sh/$selected/$(echo $query | tr ' ' '+') & while [ : ]; do sleep 1; done"
# else
# 	tmux neww bash -c "curl cht.sh/$selected~$query & while [ : ]; do sleep 1; done"
# fi

# tmux neww bash -c "tldr $selected & while [ : ]; do sleep 1; done"
# tmux neww bash -c "tldr $selected; read -n 1 -s -r -p 'Press q to close...' key; if [ \"\$key\" = 'q' ]; then exit; fi"
tmux neww bash -c "tldr $selected | less"
