#!/bin/bash

TOOL_DIR=~/tools
current_dir=$(pwd)

### Install vim plugins
install_vim() {
	if [ -f ~/.vimrc ]; then
		unlink ~/.vimrc
		unlink ~/.cscope_maps.vim
	fi
	ln -sfv $current_dir/vim/.vimrc ~/.vimrc
	ln -sfv $current_dir/vim/.cscope_maps.vim  ~/.cscope_maps.vim
	if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
		git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim && \
		vim +PluginInstall +qall
	else
		echo "[INFO] Vim plugin is already installed"
	fi
}

### Instal fzf
install_fzf() {
	if [ ! $(which fzf) ]; then
		install -d $TOOL_DIR
		git clone https://github.com/junegunn/fzf.git $TOOL_DIR/fzf && \
		bash $TOOL_DIR/fzf/install --completion --key-bindings --update-rc
	else
		echo "[INFO] fzf is already installed"
	fi
}

### Unlink
do_unlink() {
	echo "[INFO] Unlink dot file..."
	unlink ~/.bash_aliases
	unlink ~/.forgit
	unlink ~/.bash_aliases_others
	unlink ~/.tmux.conf
	unlink ~/.tmux.conf.local
	unlink ~/.inputrc
	echo "[INFO] Unlink dot file done!"
}

### Create soft link
do_link() {
	echo "[INFO] Create soft link for dotfile..."
	ln -sfv $current_dir/bash/.bash_aliases ~/.bash_aliases
	ln -sfv $current_dir/bash/.forgit ~/.forgit
	ln -sfv $current_dir/bash/.bash_aliases_others ~/.bash_aliases_others
	ln -sfv $current_dir/tmux/.tmux.conf ~/.tmux.conf
	ln -sfv $current_dir/tmux/.tmux.conf.local ~/.tmux.conf.local
	ln -sfv $current_dir/inputrc/.inputrc ~/.inputrc
	echo "[INFO] Create soft link for dotfile done!"
}

usage() {
	printf \
	"Usage: $(basename $0) <option>
	--all		Install all
	--vim		Install vim
	--fzf		Install fzf
	--help		Print this help
	\n"
	exit 0
}


### Start
if [ "$1" = "clean" ] ; then
	do_unlink
	exit 0
elif [ "$1" = "--help" ]; then
	usage
fi

do_unlink
do_link

for opt in $@; do
	case "$opt" in
	--all)
		install_vim
		install_fzf
		shift
		;;
	--vim)
		install_vim
		shift
		;;
	--fzf)
		install_fzf
		shift
		;;
	*)
		echo "Argument parsing error"
		usage
		;;
	esac
done
