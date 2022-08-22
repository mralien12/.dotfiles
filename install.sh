current_dir=$(pwd)

echo "Unlink dot file..."
unlink ~/.bash_aliases
unlink ~/.bash_aliases_others
unlink ~/.tmux.conf
unlink ~/.vimrc
echo "Unlink dot file done!"

if [ "$1" == "clean" ] ; then
	exit 0
fi

echo "Create soft link for dotfile..."
ln -sfv $current_dir/bash/.bash_aliases ~/.bash_aliases
ln -sfv $current_dir/bash/.bash_aliases_others ~/.bash_aliases_others
ln -sfv $current_dir/tmux/.tmux.conf ~/.tmux.conf
ln -sfv $current_dir/vim/.vimrc ~/.vimrc
echo "Create soft link for dotfile done!"
