local awful = require("awful")
-- local gears = require("gears")
local hostname = io.popen("uname -n"):read()

local function run_once(cmd)
	local findme = cmd
	local firstspace = cmd:find(" ")
	if firstspace then
		findme = cmd:sub(0, firstspace - 1)
	end
	awful.spawn.with_shell(string.format("pgrep -u $USER -x %s > /dev/null || (%s)", findme, cmd), false)
end

--[[
if hostname == "pcRU" then
	run_once(" xrandr \
    --output HDMI-0 --mode 2560x1440 --pos 0x0 --rotate normal \
    --output DP-0 --mode 2560x1440 --pos 2560x0 --rotate normal \
    --output DP-2 --mode 2560x1440 --pos 5120x0 --rotate normal \
  ")
elseif hostname == "vaio" then
	run_once("xrandr --output LVDS-0 --mode 1366x768 --pos 0x0 --rotate normal")
	run_once("xrandr --output VGA-0 --mode 1366x768 --rotate normal --left-of LVDS-0 --noprimary")
end
--]]

if hostname == "pcRU" then
	ImaGes = "still"
elseif hostname == "vaio" then
	ImaGes = "still"
else
	ImaGes = "still"
end

if ImaGes == "still" then
	run_once("feh --bg-fill --randomize ~/.config/awesome/theme/wallpaper/still")
elseif ImaGes == "down" then
	run_once("feh --bg-fill --randomize ~/.config/awesome/theme/wallpaper/down")
end

-- run_once('xmodmap -e "pointer = 3 2 1 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 4 5')

run_once("setxkbmap -option grp:alt_shift_toggle -layout us,ru")
-- picom
run_once("picom --config ~/.config/picom/picom.conf")

run_once("~/.local/bin/greenclip daemon")

-- return autostart
