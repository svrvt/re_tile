-- {{{ Global Variable Definitions
-- moved here in module as local variable
-- }}}

local home = os.getenv("HOME")

local hostname = io.popen("uname -n"):read()

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

if hostname == "pcRU" then
	radio_adapter = "wlx60e32716669c"
elseif hostname == "vaio" then
	radio_adapter = "wlp7s0"
end

local _M = {
	-- terminal = "xterm",
	-- terminal = "konsole",
	terminal = "alacritty",
	-- fm = "vifmrun",
	fm = "ranger",
	browser = "yandex-browser-stable",
	editor = os.getenv("editor") or "nvim",
	runner = "rofi -show",
	runner_all = "rofi-bangs.sh",
	buf_chng = "rofi-clipboard.sh",
	runner2 = "krunner",
	-- device, used in vicious widget
	--wlandev = 'wlan0',
	--wlandev = 'wlp2s0b1', --# void on notebook
	wlandev = "radio_adapter",
	modkey = "Mod4",
	altkey = "Mod1",
}

return _M
