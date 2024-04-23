#!/bin/bash

TOOL_DIR=~/tools
current_dir=$(pwd)

### Install vim plugins
install_vim() {
	ln -sfv $current_dir/vim/.vimrc ~/.vimrc
	ln -sfv $current_dir/vim/.cscope_maps.vim  ~/.cscope_maps.vim
	if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
		git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim && \
		vim +PluginInstall +qall
	else
		echo "[INFO] Vim plugin is already installed"
	fi
}

clean_vim() {
	unlink ~/.vimrc
	unlink ~/.cscope_maps.vim
}

clean_tmux() {
	unlink ~/.tmux.conf
	unlink ~/.tmux.conf.local
	unlink ~/.tmux
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

install_tmux_tpm() {
	mkdir -p $current_dir/tmux/plugins/
	if [ ! -d $current_dir/tmux/plugins/tpm ]; then
		git clone https://github.com/tmux-plugins/tpm $current_dir/tmux/plugins/tpm
	fi
}

### Unlink
do_clean() {
	echo "[INFO] Unlink dot file..."
	unlink ~/.bash_aliases
	unlink ~/.forgit
	unlink ~/.bash_aliases_others
	unlink ~/.inputrc
	clean_tmux
	clean_vim
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
	ln -sv $current_dir/tmux/ ~/.tmux
	echo "[INFO] Create soft link for dotfile done!"
}

usage() {
	printf \
	"Usage: $(basename $0) <option>
	--all		Install all
	--vim		Install vim
	--fzf		Install fzf
	--clean		Clean existing setup
	--help		Print this help
	\n"
	exit 0
}


### Start
do_clean
do_link

for opt in $@; do
	case "$opt" in
	--all)
		install_vim
		install_fzf
		install_tmux_tpm
		shift
		;;
	--clean)
		do_unlink
		clean_vim
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
