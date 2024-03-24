#!/bin/bash
this_dir="$(dirname "$(realpath "$0")")"
src_dir=~/tests
mkdir -p $src_dir
# cd $src_dir || exit
# sudo apt build-dep awesome lua-lgi -y
# sudo apt install liblua5.4-dev libxcb-xfixes0-dev liblua5.4-0-dbg librsvg2-dev libgirepository1.0-dev -y

# git clone https://github.com/lgi-devs/lgi.git 
# cd lgi || exit 
# sed -i 's|PKGS = |PKGS = lua |' lgi/Makefile
# make PREFIX=/usr LUA_VERSION=5.4 && sudo make install LUA_VERSION=5.4 PREFIX=/usr
# sudo mkdir -p /usr/local/lib/lua/5.4/
# sudo cp -r lgi/ /usr/local/lib/lua/5.4/
# sudo chmod 755 /usr/local/lib/lua/5.4/lgi

cd $src_dir || exit 
# git clone --depth=1 https://github.com/awesomewm/awesome 
git clone https://github.com/awesomewm/awesome 
cp "$this_dir"/prepare-build.sh $src_dir/awesome/
cd "$src_dir"/awesome || exit
sed -i 's|#error|//#error|' luaa.h
sed -i 's|5.4.0|5.5.0|g' awesomeConfig.cmake
# bash "$src_dir"/awesome/prepare-build.sh
bash prepare-build.sh
make package

