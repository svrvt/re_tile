#!/bin/sh
# Executed by startx (run your window manager from here)

# Default xinitrc section
userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap
## merge in defaults and keymaps
if [ -f $sysresources ]; then xrdb -merge $sysresources; fi
if [ -f $sysmodmap ]; then xmodmap $sysmodmap; fi
if [ -f "$userresources" ]; then xrdb -merge "$userresources"; fi
if [ -f "$usermodmap" ]; then xmodmap "$usermodmap"; fi
# start some nice programs
if [ -d /etc/X11/xinit/xinitrc.d ]; then
	for f in /etc/X11/xinit/xinitrc.d/?*.sh; do
		# [ -x "$f" ] && . "$f"
		test -x "$f" && . "$f"
	done
	unset f
fi

if [ "$HOST" = pcRU ]; then
	xrandr --output VGA-0 --mode 1366x768 --rotate normal
elif [ "$HOST" = vaio ]; then
	if xrandr | grep -q 'HDMI-0 connected'; then
		# xrandr --output LVDS-0 --mode 1366x768 --pos 0x0 --rotate normal
		xrandr --output HDMI-0 --mode 1920x1080 --left-of LVDS-0 --rotate normal --noprimary
	# else
	# 	xrandr --output LVDS-0 --mode 1366x768 --pos 0x0 --rotate normal
	fi
fi

# /etc/X11/xinit/xinitrc

# if [ -n "$(which luarocks 2>/dev/null)" ]; then
# 	eval $(luarocks path --bin)
# fi

# setxkbmap -option grp:alt_shift_toggle -layout us,ru &

# индикатор и переключатель раскладки клавиатуры для X11.
# gxkb &

# sxhkd & # -c $HOME/.config/sxhkd/sxhkdrc

# systemctl --user import-environment DISPLAY &

# greenclip daemon &

# exec awesome
# exex herbstluftwm

default_session="awesome"

if [ "$1" = xterm ] && [ -n "$2" ]; then
	session="$2"
elif [ -z "$1" ]; then
	if [ -e ~/.WM.default ]; then
		session="$("$HOME/.WM.default")"
	else
		session="$default_session"
	fi
else
	session="$1"
fi

printf '%s\n' "$session" >"$HOME/.WM.last"

case $session in
awesome)
	# xscreensaver &
	exec dbus-launch --sh-syntax --exit-with-session awesome
	;;

herbst | herbstluftwm)
	xscreensaver &
	exec herbstluftwm --locked
	;;

bspwm)
	xscreensaver &
	exec bspwm
	;;

cinnamon)
	xscreensaver &
	exec cinnamon-session
	;;

dwm)
	xscreensaver &
	exec dwm
	;;

kde)
	xscreensaver &
	exec startkde
	;;

mate)
	xscreensaver &
	exec mate-session
	;;

openbox)
	xscreensaver &
	exec openbox-session
	;;

unity)
	xscreensaver &
	exec unity
	;;

xfce | xfce4)
	xscreensaver &
	exec startxfce4
	;;

xmonad)
	xscreensaver &
	exec xmonad
	;;

# No known session, try to run it as command
*)
	xscreensaver &
	exec "$session"
	;;
esac
