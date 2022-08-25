current_dir=$(pwd)

echo "Unlink dot file..."
unlink ~/.bash_aliases
unlink ~/.forgit
unlink ~/.bash_aliases_others
unlink ~/.tmux.conf
unlink ~/.tmux.conf.local
unlink ~/.vimrc
unlink ~/.inputrc
echo "Unlink dot file done!"

if [ "$1" == "clean" ] ; then
	exit 0
fi

echo "Create soft link for dotfile..."
ln -sfv $current_dir/bash/.bash_aliases ~/.bash_aliases
ln -sfv $current_dir/bash/.forgit ~/.forgit
ln -sfv $current_dir/bash/.bash_aliases_others ~/.bash_aliases_others
ln -sfv $current_dir/tmux/.tmux.conf ~/.tmux.conf
ln -sfv $current_dir/tmux/.tmux.conf.local ~/.tmux.conf.local
ln -sfv $current_dir/vim/.vimrc ~/.vimrc
ln -sfv $current_dir/inputrc/.inputrc ~/.inputrc
echo "Create soft link for dotfile done!"
