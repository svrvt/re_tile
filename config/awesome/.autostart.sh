#!/bin/bash

function run {
	if ! pgrep "$1"; then
		"$@" &
	fi
}

run setxkbmap -option grp:alt_shift_toggle -layout us,ru

if [[ $HOSTNAME =~ "pcRU" ]]; then
	THEMES=still
elif [[ $HOSTNAME =~ "vaio" ]]; then
	THEMES=still
else
	THEMES=still
fi

if [[ $THEMES =~ "still" ]]; then
	run feh --bg-fill --randomize ~/.config/awesome/themes/wallpaper/still
elif [[ $THEMES =~ "down" ]]; then
	run feh --bg-fill --randomize ~/.config/awesome/themes/wallpaper/down
fi

# run nm-applet
# run kbdd
# run xscreensaver -nosplash
# run nm-tray
# run connman-ui-gtk

# индикатор и переключатель раскладки клавиатуры для X11.
# gxkb

# привязки клавиш
# run sxhkd # -c $HOME/.config/sxhkd/sxhkdrc

run /home/ru/.local/bin/greenclip daemon

# run dex /home/ru/.config/autostart/Yandex.Disk.desktop

# run dex $HOME/.config/autostart/arcolinux-welcome-app.desktop
#run xrandr --output VGA-1 --primary --mode 1360x768 --pos 0x0 --rotate normal
#run xrandr --output HDMI2 --mode 1920x1080 --pos 1920x0 --rotate normal --output HDMI1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output VIRTUAL1 --off
#autorandr horizontal
# run nm-applet
#run caffeine
# run pamac-tray
# run variety
# run xfce4-power-manager
# run blueberry-tray
# run /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1
# run numlockx on
# run volumeicon
#run nitrogen --restore
# run conky -c $HOME/.config/awesome/system-overview
#run applications from startup
#run firefox
#run atom
#run dropbox
#run insync start
#run spotify
#run ckb-next -b
# run discord
#run telegram-desktop
