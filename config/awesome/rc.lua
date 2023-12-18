pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")

-- Theme handling library
local beautiful = require("beautiful")

-- Miscellanous awesome library
local menubar = require("menubar")

RC = {} -- global namespace, on top before require any modules
RC.vars = require("main.user-variables")
modkey = RC.vars.modkey
altkey = RC.vars.altkey

-- Error handling
require("main.error-handling")

-- Themes
require("main.theme")

-- -- --

-- Calling All Module Libraries

-- Custom Local Library
local main = {
	layouts = require("main.layouts"),
	tags = require("main.tags"),
	menu = require("main.menu"),
	rules = require("main.rules"),
	brockcochranfunc = require("main.brockcochranfunc"),
}

-- Custom Local Library: Keys and Mouse Binding
local binding = {
	globalbuttons = require("binding.globalbuttons"),
	clientbuttons = require("binding.clientbuttons"),
	globalkeys = require("binding.globalkeys"),
	clientkeys = require("binding.clientkeys"),
	bindtotags = require("binding.bindtotags"),
}

-- Layouts
RC.layouts = main.layouts()

-- Tags
RC.tags = main.tags()

-- Menu
RC.mainmenu = awful.menu({ items = main.menu() }) -- in globalkeys
RC.launcher = awful.widget.launcher({ image = beautiful.awesome_icon, menu = RC.mainmenu })
menubar.utils.terminal = RC.vars.terminal

-- Mouse and Key bindings
RC.globalkeys = binding.globalkeys()
RC.globalkeys = binding.bindtotags(RC.globalkeys)

-- Set root
root.buttons(binding.globalbuttons())
root.keys(RC.globalkeys)

-- Rules
awful.rules.rules = main.rules(binding.clientkeys(), binding.clientbuttons())

-- Signals
require("main.signals")

-- Locale
os.setlocale(os.getenv("LANG"))

-- Gaps
beautiful.useless_gap = 2

-- Autostart

require("autostart")

-- awful.spawn.with_shell("~/.config/awesome/autostart.sh")
-- awful.spawn.with_shell("picom -b --config  $HOME/.config/awesome/picom.conf")
-- awful.spawn.with_shell("picom")
-- awful.spawn.with_shell("yandex-disk start")

--awful.spawn.with_shell(fm)
--awful.spawn.with_shell(terminal)

-- Autostarting programm
-- интернет
-- os.execute("pgrep -u $USER -x nm-applet || (nm-applet &)")
-- os.execute("pgrep -u $USER -x kbdd || (kbdd &)")
-- os.execute("pgrep -u $USER -x xscreensaver || (xscreensaver -nosplash &)")

-- Statusbar: Wibar
local statusbar = require("statusbar.my_bar.statusbar")
-- local statusbar = require("statusbar.default.statusbar")
-- local statusbar = require("statusbar.vicious.statusbar")

statusbar()
