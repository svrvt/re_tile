#!/bin/bash

# Fetch submodules
# git submodule update --init --recursive

RC='\e[0m'
RED='\e[31m'
YELLOW='\e[33m'
GREEN='\e[32m'
GREEN2='[32;1m'
WHITE='[37;1m'
BLUE='[34;1m'

RV='\u001b[7m'

THIS_REPO_PATH="$(dirname "$(realpath "$0")")"
# THIS_REPO_PATH=$HOME/REPOS/reinst
DOT_CFG_PATH=$THIS_REPO_PATH/config
DOT_HOME_PATH=$THIS_REPO_PATH/home
USR_CFG_PATH=$HOME/.config
SRC_DIR=$HOME/src/lua
FONT_DIR=$HOME/.local/share/fonts
# USR_CFG_PATH=$THIS_REPO_PATH/test

configExists() {
	[[ -e "$1" ]] && [[ ! -L "$1" ]]
}

command_exists() {
	command -v $1 >/dev/null 2>&1
}

checkEnv() {
	## Check Package Handeler
	PACKAGEMANAGER='apt dnf pacman'
	for pgm in ${PACKAGEMANAGER}; do
		if command_exists ${pgm}; then
			PACKAGER=${pgm}
			echo -e ${RV}"Using ${pgm}"
		fi
	done

	if [ -z "${PACKAGER}" ]; then
		echo -e "${RED}Can't find a supported package manager"
		exit 1
	fi

	## Check if the current directory is writable.
	PATHs="$THIS_REPO_PATH $USR_CFG_PATH "
	for path in $PATHs; do
		if [[ ! -w ${path} ]]; then
			echo -e "${RED}Can't write to ${path}${RC}"
			exit 1
		fi
	done
}

checkEnv

function install_packages {
	DEPENDENCIES='xauth xorg i3lock'

	echo -e "${YELLOW}Installing required packages...${RC}"
	if [[ $PACKAGER == "pacman" ]]; then
		if ! command_exists yay; then
			echo "Installing yay..."
			sudo "${PACKAGER} --noconfirm -S base-devel"
			$(cd /opt && sudo git clone https://aur.archlinux.org/yay-git.git && sudo chown -R \
				${USER}:${USER} ./yay-git && cd yay-git && makepkg --noconfirm -si)
		else
			echo "Command yay already installed"
		fi
		yay --noconfirm -S ${DEPENDENCIES}
	else
		sudo ${PACKAGER} install -yq ${DEPENDENCIES}
	fi
}

function back_sym {
	# перед создание линков делает бекапы только тех пользовательских конфикураций,
	# файлы которых есть в ./config ./home
	mkdir -p "$USR_CFG_PATH"
	echo -e "${RV}${YELLOW} Backing up existing files... ${RC}"
	for config in $(ls ${DOT_CFG_PATH}); do
		if configExists "${USR_CFG_PATH}/${config}"; then
			echo -e "${YELLOW}Moving old config ${USR_CFG_PATH}/${config} to ${USR_CFG_PATH}/${config}.old${RC}"
			if ! mv "${USR_CFG_PATH}/${config}" "${USR_CFG_PATH}/${config}.old"; then
				echo -e "${RED}Can't move the old config!${RC}"
				exit 1
			fi
			echo -e "${WHITE} Remove backups with 'rm -ir ~/.*.old && rm -ir ~/.config/*.old' ${RC}"
		fi
		echo -e "${GREEN}Linking ${DOT_CFG_PATH}/${config} to ${USR_CFG_PATH}/${config}${RC}"
		if ! ln -snf "${DOT_CFG_PATH}/${config}" "${USR_CFG_PATH}/${config}"; then
			echo echo -e "${RED}Can't link the config!${RC}"
			exit 1
		fi
	done

	# for config in $(ls ${DOT_HOME_PATH}); do
	# 	if configExists "$HOME/.${config}"; then
	# 		echo -e "${YELLOW}Moving old config ${HOME}/.${config} to ${HOME}/.${config}.old${RC}"
	# 		if ! mv "${HOME}/.${config}" "${HOME}/.${config}.old"; then
	# 			echo -e "${RED}Can't move the old config!${RC}"
	# 			exit 1
	# 		fi
	# 	fi
	# 	echo -e "${GREEN}Linking ${DOT_HOME_PATH}/${config} to ${HOME}/.${config}${RC}"
	# 	if ! ln -snf "${DOT_HOME_PATH}/${config}" "${HOME}/.${config}"; then
	# 		echo echo -e "${RED}Can't link the config!${RC}"
	# 		exit 1
	# 	fi
	# done

}

# Lua
function install_lua {
	if ! command_exists lua; then
		echo -e "${RV} Installing Lua ${RC}"
		mkdir -p "$SRC_DIR"
		cd "$SRC_DIR" || return
		curl -R -O http://www.lua.org/ftp/lua-5.3.5.tar.gz
		tar -zxf lua-5.3.5.tar.gz
		rm -rf lua-5.3.5.tar.gz
		cd lua-5.3.5 || return
		make linux test
		sudo make install
	else
		echo -e "${RV} Lua is installed ${RC}"
	fi
}

# Luarocks
function install_luarocks {
	if command_exists lua; then
		if ! command_exists luarocks; then
			echo -e "${RV} Installing Luarocks... ${RC}"
			mkdir -p "$SRC_DIR"
			cd "$SRC_DIR" || return
			wget https://luarocks.org/releases/luarocks-3.8.0.tar.gz
			tar -zxpf luarocks-3.8.0.tar.gz
			rm -rf luarocks-3.8.0.tar.gz
			cd luarocks-3.8.0 || return
			./configure --with-lua-include=/usr/local/include
			make
			sudo make install
		else
			echo -e "${RV} Luarocks is installed${RC}"
		fi
	else
		echo -e "${RED}Lua is not installed!${RC}"
		install_lua
		install_luarocks
	fi
}

# Awesome
function install_awesome {
	if ! command_exists awesome; then
		echo -e "${RV} Installing awesome... ${RC}"
		sudo apt install awesome awesome-extra
	else
		echo -e "${RV} Awesome is installed ${RC}"
	fi
}

function install_fonts {
	echo -e "\u001b[7m Installing fonts \u001b[0m"
	mkdir -p "$FONT_DIR"
	cp "$THIS_REPO_PATH"/set/awesomewm-font.ttf ~/.local/share/fonts/
	sudo fc-cache -fr
}

function all {
	echo -e "\u001b[7m Setting up Dotfiles... \u001b[0m"
	install_packages
	back_sym
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
echo -e "  \u001b[34;1m (a) ALL \u001b[0m"
echo -e "  \u001b[34;1m (p) install packages \u001b[0m"
echo -e "  \u001b[34;1m (s) backup and symlink \u001b[0m"
echo -e "  \u001b[34;1m (l) install lua \u001b[0m"
echo -e "  \u001b[34;1m (r) install luarocks (5,6,13) \u001b[0m"
echo -e "  \u001b[34;1m (w) install awesome \u001b[0m"
echo -e "  \u001b[34;1m (f) fonts \u001b[0m"

echo -e "  \u001b[31;1m (*) Anything else to exit \u001b[0m"

echo -en "\u001b[32;1m ==> \u001b[0m"

read -r option

case $option in

"a")
	all
	;;

"p")
	install_packages
	;;

"s")
	back_sym
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
