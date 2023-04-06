-- {{{ Global Variable Definitions
-- moved here in module as local variable
-- }}}

local home = os.getenv("HOME")

local _M = {
  -- terminal = "xterm",
  -- terminal = "konsole",
  terminal = "alacritty",
  -- fm = "vifmrun",
  fm = "ranger",
  browser = "yandex-browser-stable",
  editor = os.getenv("editor") or "nvim",
  runner = "rofi -show",
  -- runner = "/home/ru/reinst/scripts/rofi/rofi-bangs.sh",
  buf_chng = 'rofi -modi "clipboard:greenclip print" -show clipboard',
  -- device, used in vicious widget
  --wlandev = 'wlan0',
  --wlandev = 'wlp2s0b1', --# void on notebook
  wlandev = 'wlp7s0',
  modkey = "Mod4",
  -- altkey = "Mod1",

}

return _M
