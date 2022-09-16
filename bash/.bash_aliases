### Environment Variables ####
PATH=$PATH:~/tools/bin
# Default options for fuzzy finder
export FZF_DEFAULT_OPTS='--height 30% --layout=reverse --border --color=bg+:#3B4252,fg+:#f7f603'
# Setting up PS1 value
export PS1="[\u@\h \[\e[32m\]\w \[\e[91m\]\$(parse_git_branch)\[\e[00m\]]\n> "

### Common Alias ###
alias recipes_kernel='petatop; cd project-spec/meta-user/recipes-kernel/linux'
alias recipes_apps='petatop; cd project-spec/meta-user/recipes-apps'
alias recipes_dt='petatop; cd project-spec/meta-user/recipes-bsp/device-tree/files'
alias recipes_uboot='petatop; cd project-spec/meta-user/recipes-bsp/u-boot'
alias recipes_fsboot='petatop; cd project-spec/meta-user/recipes-bsp/fs-boot'

alias view_pl_dts='petatop; vim components/plnx_workspace/device-tree/device-tree/pl.dtsi'
alias view_system_dts='petatop; vim project-spec/meta-user/recipes-bsp/device-tree/files/system-user.dtsi'
alias cpimage='petatop; cp images/linux/BOOT.BIN images/linux/boot.scr images/linux/image.ub ~/.; cd - > /dev/null'

alias sl='ls' # in case of mistyping
alias lsa='ls -alht --color=auto' # in case of mistyping
# remove newline character and copy to system clipboard
# usage example: pwd | c
alias c="tr -d '\n' | xclip -selection clipboard" 
alias v='vim'
alias fc='fzf | c'
alias brc='vim ~/.bashrc'
alias bal='vim ~/.bash_aliases'
alias dotfile='cd ~/.dotfiles'

### Function ###
petagethw() {
	petalinux-config --get-hw-description=$1
}

petatop() {
        local is_in_petalinux=0
        local current_dir=$(pwd)
        while true
        do
                if [ -f $current_dir/.petalinux/metadata ]; then
                        is_in_petalinux=1
                        break
                fi

                if [ "$current_dir" == "/home/$USER" ]; then
                        break
                fi
                current_dir=$(dirname $current_dir)
        done

        if [ $is_in_petalinux -eq 1 ]; then
                cd $current_dir
        fi
}

fkill() {
        (date; ps -ef) |
          fzf --bind='ctrl-r:reload(date; ps -ef)' \
              --header=$'Press CTRL-R to reload\n\n' --header-lines=2 \
              --preview='echo {}' --preview-window=down,3,wrap \
              --layout=reverse --height=80% | awk '{print $2}' | xargs kill -9
}

# tm - create new tmux session, or switch to existing one. Works from within tmux too. (@bag-man)
# `tm` will allow you to select your tmux session via fzf.
# `tm irc` will attach to the irc session (if it exists), else it will create it.

tm() {
	[[ -n "$TMUX" ]] && change="switch-client" || change="attach-session"
	if [ $1 ]; then
		tmux $change -t "$1" 2>/dev/null || (tmux new-session -d -s $1 && tmux $change -t "$1"); return
	fi
	session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --exit-0) &&  tmux $change -t "$session" || echo "No sessions found."
}

parse_git_branch() { git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'; }

# fcd - cd to selected directory including hidden directories
fcd() {
	local dir
	dir=$(find ${1:-.} -type d 2> /dev/null | fzf +m) && cd "$dir"
}

# Modified version where you can press
#   - CTRL-O to open with `open` command,
#   - CTRL-E or Enter key to open with the $EDITOR
fo() {
	IFS=$'\n' out=("$(fzf-tmux --query="$1" --exit-0 --expect=ctrl-o,ctrl-e)")
	key=$(head -1 <<< "$out")
	file=$(head -2 <<< "$out" | tail -1)
	if [ -n "$file" ]; then
		[ "$key" = ctrl-o ] && open "$file" || ${EDITOR:-vim} "$file"
	fi
}

# Open recent file in .viminfo
foh() {
	local file
	file=$(grep '^>' ~/.viminfo|cut -c3-|sed 's,~,'$HOME',' | \
		fzf --header=$'Recent files\n\n') && ${EDITOR:-vim} "$file"
	
}

# fgst - pick files from `git status -s` 
is_in_git_repo() {
	git rev-parse HEAD > /dev/null 2>&1
}

# Git diff modified file
fgd() {
	# "Nothing to see here, move along"
	is_in_git_repo || return

	local fd=$(git status -s . | fzf -m)
	[ "$fd" == "" ] && return
	git diff $(echo "$fd" | sed "s/.* //")
}

# Git add
fga() {
	# "Nothing to see here, move along"
	is_in_git_repo || return

	local fd=$(git status -s . | fzf -m)
	[ "$fd" == "" ] && return
	git add $(echo "$fd" | sed "s/.* //")
}

# fco - checkout git branch/tag
fgc() {
	# "Nothing to see here, move along"
	is_in_git_repo || return

	local tags branches target
	branches=$(
		git --no-pager branch --all \
			--format="%(if)%(HEAD)%(then)%(else)%(if:equals=HEAD)%(refname:strip=3)%(then)%(else)%1B[0;34;1mbranch%09%1B[m%(refname:short)%(end)%(end)" \
		| sed '/^$/d') || return
	tags=$(
		git --no-pager tag | awk '{print "\x1b[35;1mtag\x1b[m\t" $1}') || return
	target=$(
		(echo "$branches"; echo "$tags") |
		fzf --no-hscroll --no-multi -n 2 \
			--ansi) || return
	git checkout $(awk '{print $2}' <<<"$target" )
}

gitroot() {
	local dir
	is_in_git_repo || return
	dir=$(git rev-parse --show-toplevel)
	cd $dir
}

#### Forgit ###
[ -f ~/.forgit/forgit.sh ] && source ~/.forgit/forgit.sh
#### Aliases for each machine ###
hostname=$(cat /etc/hostname)
# Add aliases for VVDN Server 172.16.237.159/vvdnhn
if [ "$hostname" = "vvdnadmin" ] | [ "$hostname" = "vvdnhn" ]; then
	if [ -f ~/.bash_aliases_others/server159/bash_aliases ]; then
		. ~/.bash_aliases_others/server159/bash_aliases
	fi
fi
# Add aliases for my local virtualbox
if [ "$hostname" == "hoa-VirtualBox" ]; then
	if [ -f ~/.bash_aliases_others/local_virtualbox/bash_aliases ]; then
		. ~/.bash_aliases_others/local_virtualbox/bash_aliases
	fi
fi
