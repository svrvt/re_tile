#!/bin/bash

function backup_configs {
	echo -e "\u001b[33;1m Backing up existing files... \u001b[0m"
	# mv -iv ~/.config/awesome    ~/.config/awesome.old
	# mv -iv ~/.config/    ~/.config/

	# mv -iv ~/.            ~/.
	# mv -iv ~/.            ~/.
	echo -e "\u001b[36;1m Remove backups with 'rm -ir ~/.*.old && rm -ir ~/.config/*.old'. \u001b[0m"
}

## -f удаляет имеющийся линк
function setup_symlinks {
	echo -e "\u001b[7m Setting up symlinks... \u001b[0m"
	mkdir -p ~/.config
	# ln -sfnv "$PWD/config/nvim/"          ~/.config/
	# ln -sfnv "$PWD/"                ~/.

	# ln -sfnv "$PWD/.gitignore.global" ~/
	# ln -sfnv "$PWD/.p10k.zsh" ~/

}

function install_lua {
	echo -e "\u001b[7m Installing Lua...\u001b[0m"
	# Lua
	# mkdir -p ~/Downloads
	# cd ~/Downloads
	curl -R -O http://www.lua.org/ftp/lua-5.3.5.tar.gz
	tar -zxf lua-5.3.5.tar.gz
	rm -rf lua-5.3.5.tar.gz
	cd lua-5.3.5
	make linux test
	sudo make install
	cd -
	rm -rf lua-5.3.5
}

function install_luarocks {
	# Luarocks
	echo -e "\u001b[7m Installing Luarocks...\u001b[0m"
	# cd ~/Downloads
	wget https://luarocks.org/releases/luarocks-3.8.0.tar.gz
	tar -zxpf luarocks-3.8.0.tar.gz
	rm -rf luarocks-3.8.0.tar.gz
	cd luarocks-3.8.0
	./configure --with-lua-include=/usr/local/include
	make
	sudo make install
	cd -
	rm -rf luarocks-3.8.0
}

function install_awesome {
	# Awesome
	echo -e "\u001b[7m Installing Awesome...\u001b[0m"
	# cd ~/downloads/
	sudo apt install awesome awesome-extra

	mkdir -p ~/REPOS/wm
	git clone https://github.com/RU927/wm ~/REPOS/wm
	# git clone git@github.com:RU927/wm.git ~/REPOS/wm
	rm -r ~/.config/awesome/
	ln -svf ~/REPOS/wm/awesome ~/.config/
	# git remote add origin git@github.com:RU927/wm
}

function install_fonts {
	echo -e "\u001b[7m Installing fonts \u001b[0m"
	mkdir -p ~/.local/share/fonts
	# cp $PWD/set/awesomewm-font.ttf ~/.local/share/fonts/
	sudo fc-cache -fr
}

function all {
	echo -e "\u001b[7m Setting up Dotfiles... \u001b[0m"
	install_packages
	backup_configs
	setup_symlinks
	install_lua
	install_luarocks
	install_awesome
	install_fonts
	echo -e "\u001b[7m Done! \u001b[0m"
}

if [ "$1" = "--all" -o "$1" = "-a" ]; then
	all
	exit 0
fi

# Menu TUI
echo -e "\u001b[32;1m Setting up Dotfiles...\u001b[0m"

echo -e " \u001b[37;1m\u001b[4mSelect an option:\u001b[0m"
echo -e "  \u001b[34;1m (a) ALL(1-3) \u001b[0m"
echo -e "  \u001b[34;1m (l) lua \u001b[0m"
echo -e "  \u001b[34;1m (r) luarocks (5,6,13) \u001b[0m"
echo -e "  \u001b[34;1m (w) awesome \u001b[0m"
echo -e "  \u001b[34;1m (f) fonts \u001b[0m"

echo -e "  \u001b[31;1m (*) Anything else to exit \u001b[0m"

echo -en "\u001b[32;1m ==> \u001b[0m"

read -r option

case $option in

"a")
	all
	;;

"l")
	install_lua
	;;

"r")
	install_luarocks
	;;

"w")
	install_awesome
	;;

"f")
	install_fonts
	;;

*)
	echo -e "\u001b[31;1m Invalid option entered, Bye! \u001b[0m"
	exit 0
	;;
esac

exit 0
