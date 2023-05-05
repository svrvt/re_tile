-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")

-- Widget and layout library
local wibox = require("wibox")

-- Theme handling library
local beautiful = require("beautiful")

-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- Math library for moving client forward/back a tag
local gmath = require("gears.math")

-- Personal stuff
dofile("/home/brock/.config/awesome/personal-stuff.lua")

-- Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
	naughty.notify({ preset = naughty.config.presets.critical,
		title = "Oops, there were errors during startup!",
		text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
	local in_error = false
		awesome.connect_signal("debug::error", function (err)
		-- Make sure we don't go into an endless error loop
		if in_error then return end
		in_error = true

		naughty.notify({ preset = naughty.config.presets.critical,
			title = "Oops, an error happened!",
			text = tostring(err) })
		in_error = false
	end)
end

-- Variable definitions
-- Themes define colors, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_configuration_dir().."zenburn/theme.lua")

-- Set default terminal.
terminal = "urxvtc"

editor = os.getenv("EDITOR") or "editor"
editor_cmd = terminal.." -e "..editor

-- Default modkeys.
modkey = "Mod4"
altkey = "Mod1"

-- Table of layouts to cover with awful.layout.inc, order matters.
local l = awful.layout.suit
awful.layout.layouts = {
	l.floating,
	l.tile,
	l.spiral.dwindle,
	l.fair,
	l.max,
}

mymainmenu = awful.menu({ items = { { "kb toggle", "bash -c 'keyboard-toggle'" } } })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it

-- I no longer use this because I just use the English US International keyboard instead of switching between the two.
-- Keyboard map indicator and switcher
-- local mykeyboardlayout = awful.widget.keyboardlayout()

-- This is for my current year calendar. I did not feel like setting a reminder to update this every Jan. 1. In 2023, this caused some confusion because it did not roll over automatically.
yr = os.date("%Y")

-- My popup calendar, source adapted from: https://pavelmakhov.com/2017/03/calendar-widget-for-awesome
function cal_notify(cal_pref, pref_screen)
	if cal_notification == nil then
		awful.spawn.easy_async([[bash -c "]]..cal_pref..[[ | sed 's/_.\(.\)/+\1-/g;s/$//g;/]]..yr..[[$/d'"]],
		function(stdout, stderr, reason, exit_code)
			cal_notification = naughty.notify {
				text = string.gsub(string.gsub(stdout, "+", "<span background='#85492e'>"), "-", "</span>"),
				timeout = 0,
				margin = 20,
				screen = pref_screen,
				width = auto,
				destroy = function() cal_notification = nil end
			}
		end)
	else
		naughty.destroy(cal_notification)
		-- naughty.destroy_all_notifications()
	end
end

-- Create a textclock widget and attach calendar to it on click.
local mytextclock = wibox.widget.textclock (" %d %b %I:%M %p ")
mytextclock:connect_signal("button::release", function() cal_notify("cal "..yr) end)

-- Check if I am on my SSD install.
local f=io.open("/home/brock/.myssd","r")
if f~=nil then
	io.close(f)
	myssd = true
end

-- Check if I am on the ThinkPad (using my SSD).
local handle = io.popen("lscpu")
local result = handle:read("*a")
handle:close()
if string.find(result, "2520M") then
	thinkpad = true
end

-- Check if I am on my Pinebook Pro.
local f=io.open("/home/brock/.mylaptop","r")
if f~=nil then
	io.close(f)
	mylaptop = true
end

-- Check if I am on my home computer.
local f=io.open("/home/brock/.myhomecomputer","r")
if f~=nil then
	io.close(f)
	myhomecomputer = true
end

-- Check if I am on my work computer.
local f=io.open("/home/brock/.myworkcomputer","r")
if f~=nil then
	io.close(f)
	myworkcomputer = true
end

-- Add battery status if I am using my laptop.
if mylaptop or thinkpad then
	battery_status = awful.widget.watch("battery-status", 60)
end

-- VPN notification if running
if not myworkcomputer then
	vpncheck = awful.widget.watch("vpn-check", 60)
end

-- Actions for when I click on my taglist buttons
local taglist_buttons = gears.table.join(
	awful.button({ }, 1, function(t) t:view_only() end)
	-- awful.button({ }, 3, awful.tag.viewtoggle)
)

-- Actions for when I click on my tasklist buttons
local tasklist_buttons = gears.table.join(
	awful.button({ }, 1, function (c)
		if c == client.focus then
			c.minimized = true
		else
			c:emit_signal(
			"request::activate",
			"tasklist",
			{raise = true}
			)
		end
	end)
)

local function set_wallpaper(s)
	if beautiful.wallpaper then
		bcwallpaper = "/home/brock/Nextcloud/1-Personal/Linux/5760x1080/monterrey.jpg"
		if mylaptop then
			gears.wallpaper.maximized(bcwallpaper)
		else
			gears.wallpaper.set(gears.surface(bcwallpaper))
		end
	end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

-- These are my tag names.
term="  1 • terminal  "
nave="  2 • navegador  "
mezc="   3 • mezcla   "
pala="  4 • palabras  "
vari="   5 • varios   "
util=" 6 • utilidades "

-- For some reason, I needed a space on the wibar on my Pinebook Pro.
if not mylaptop then
	spacer=wibox.widget.textbox(' ')
end

-- Without this setting, it defaults to 16px icons which stretch to my wibar height of 24px.
awesome.set_preferred_icon_size(32)

awful.screen.connect_for_each_screen(function(s)
	set_wallpaper(s)

	-- Set my tags for each screen with their own preferred layouts.
	awful.tag.add(term, { layout = l.tile, screen = s, selected = true, })
	awful.tag.add(nave, { layout = l.max, screen = s, })
	awful.tag.add(mezc, { layout = l.tile, screen = s, })
	awful.tag.add(pala, { layout = l.tile, screen = s, })
	awful.tag.add(vari, { layout = l.tile, screen = s, })
	awful.tag.add(util, { layout = l.tile, screen = s, })

	-- Create an imagebox widget which will contain an icon indicating which layout we're using.
	-- We need one layoutbox per screen.
	s.mylayoutbox = awful.widget.layoutbox(s)
	s.mylayoutbox:buttons(gears.table.join(awful.button({ }, 1, function() awful.layout.inc( 1) end)))

	-- Create a taglist widget
	s.mytaglist = awful.widget.taglist {
		screen = s,
		-- There is no point in showing an empty tag.
		filter  = awful.widget.taglist.filter.noempty,
		-- filter  = awful.widget.taglist.filter.all,
		buttons = taglist_buttons,
	}

	-- Create a tasklist widget
	s.mytasklist = awful.widget.tasklist {
		screen = s, filter = awful.widget.tasklist.filter.currenttags, buttons = tasklist_buttons,
	}

	-- Create the wibox
	s.mywibox = awful.wibar({ position = "top", screen = s, height = 28 })

	-- Add widgets to the wibox
	if s.index == 1 then
		-- I only want the system tray, clock, etc. to be on screen one and not on every screen.
		s.mywibox:setup {
			layout = wibox.layout.align.horizontal,
			{ layout = wibox.layout.fixed.horizontal,
			s.mytaglist,
			},
			s.mytasklist,
			{ layout = wibox.layout.fixed.horizontal,
			vpncheck, spacer, wibox.widget.systray(), battery_status, mytextclock, s.mylayoutbox,
			},
		}
	else
		s.mywibox:setup {
			layout = wibox.layout.align.horizontal,
			{ layout = wibox.layout.fixed.horizontal,
			s.mytaglist,
			},
			s.mytasklist,
			{ layout = wibox.layout.fixed.horizontal,
			s.mylayoutbox,
			},
		}
	end
end)

-- Mouse binding when I click on an empty screen
root.buttons(gears.table.join(awful.button({ }, 3, function() mymainmenu:toggle() end)))

-- These two functions are for moving the current client to the next/previous tag and following view to that tag.
local function move_to_previous_tag()
	local c = client.focus
	if not c then return end
	local t = c.screen.selected_tag
	local tags = c.screen.tags
	local idx = t.index
	local newtag = tags[gmath.cycle(#tags, idx - 1)]
	c:move_to_tag(newtag)
	awful.tag.viewprev()
end
local function move_to_next_tag()
	local c = client.focus
	if not c then return end
	local t = c.screen.selected_tag
	local tags = c.screen.tags
	local idx = t.index
	local newtag = tags[gmath.cycle(#tags, idx + 1)]
	c:move_to_tag(newtag)
	awful.tag.viewnext()
end

-- There is no reason to navigate next or previous in my tag list and have to pass by empty tags in route to the next tag with a client. The following two functions bypass the empty tags when navigating to next or previous.
function view_next_tag_with_client()
	local initial_tag_index = awful.screen.focused().selected_tag.index
	while (true) do
		awful.tag.viewnext()
		local current_tag = awful.screen.focused().selected_tag
		local current_tag_index = current_tag.index
		if #current_tag:clients() > 0 or current_tag_index == initial_tag_index then
			return
		end
	end
end
function view_prev_tag_with_client()
	local initial_tag_index = awful.screen.focused().selected_tag.index
	while (true) do
		awful.tag.viewprev()
		local current_tag = awful.screen.focused().selected_tag
		local current_tag_index = current_tag.index
		if #current_tag:clients() > 0 or current_tag_index == initial_tag_index then
			return
		end
	end
end

-- Toggle showing the desktop
local show_desktop = false
function show_my_desktop()
	if show_desktop then
		for _, c in ipairs(client.get()) do
			c:emit_signal(
				"request::activate", "key.unminimize", {raise = true}
			)
		end
		show_desktop = false
	else
		for _, c in ipairs(client.get()) do
			c.minimized = true
		end
		show_desktop = true
	end
end

-- Firefox loads by default on whichever screen has a window already on it and opens a new tab. The following allows me to launch Firefox on the screen of my choosing whether or not there is already a Firefox window on it.
function firefox_launch(url)
	local screen = awful.screen.focused()
	local t = screen.tags[2]
	if #t:clients() > 0 then
		awful.spawn("firefox "..url)
	else
		awful.spawn("firefox -new-window "..url)
	end
end

-- This is my clipboard script.
function cb_launch()
	for _, c in ipairs(client.get()) do
		if c.name == 'cb - clipboard' then
			c:kill()
			return
		end
	end
	local t = awful.screen.focused().selected_tag
	awful.spawn("urxvt -title 'cb - clipboard' -e cb", {floating = true, placement = awful.placement.centered, tag = t})
end

-- This launches a file or application (for example Speedcrunch). However, if it is already loaded it automatically switches to it instead.
function bc_launch(title, cmd, rules)
	for _, c in ipairs(client.get()) do
		if c.name == title then
			c:jump_to()
			return
		end
	end
	awful.spawn(cmd, rules)
end

-- I want certain applications to launch on preferred screens whether using multiple monitors or not. (I sync this config between my different installs.)
if mylaptop or thinkpad then
	md_one, rt_one = 1, 1
elseif myssd then
	md_one, rt_one = 1, 2
else
	md_one, rt_one = 2, 3
end

-- Key bindings
globalkeys = gears.table.join(
	-- awful.key({ modkey }, "s", hotkeys_popup.show_help,
	-- 	{description="show help", group="awesome"}),
	awful.key({ }, "XF86Sleep", function() awful.spawn.with_shell("screenlock; systemctl suspend") end,
		{description="lock screen and suspend", group="utilities"}),

	-- Horizontal Vim navigation keys to go left and right on tags.
	awful.key({ altkey }, "h", function() view_prev_tag_with_client() end,
	 	{description = "view previous", group = "tag"}),
	awful.key({ altkey }, "l", function() view_next_tag_with_client() end,
	 	{description = "view next tag with client on it", group = "tag"}),

	-- I use "n" here to go the the "next" client or "next" in reverse.
	awful.key({ altkey }, "n", function() awful.client.focus.byidx(1) end,
		{description = "focus next by index", group = "client"}),
	awful.key({ modkey, altkey }, "n", function() awful.client.focus.byidx(-1) end,
		{description = "focus previous by index", group = "client"}),

	-- Increase and decrease the number of master clients. I only use this on tag 1.
	awful.key({ modkey, "Control" }, "m", function () awful.tag.incnmaster( 1, nil, true) end,
		{description = "increase the number of master clients", group = "layout"}),
	awful.key({ modkey, altkey }, "m", function () awful.tag.incnmaster(-1, nil, true) end,
		{description = "decrease the number of master clients", group = "layout"}),

	-- Vertical Vim navigation keys
	awful.key({ modkey, "Shift" }, "j", function() awful.client.swap.byidx(1) end,
		{description = "swap with next client by index", group = "client"}),
	awful.key({ modkey, "Shift" }, "k", function() awful.client.swap.byidx(-1) end,
		{description = "swap with previous client by index", group = "client"}),

	-- Horizontal Vim navigation keys to go left and right a screen
	awful.key({ modkey }, "h", function() awful.screen.focus_relative(-1) end,
		{description = "focus the previous screen", group = "screen"}),
	awful.key({ modkey }, "l", function() awful.screen.focus_relative(1) end,
		{description = "focus the next screen", group = "screen"}),

	-- Horizontal Vim navigation keys to move the client to the next or previous tag and follow there
	awful.key({ modkey, altkey }, "h", function(c) move_to_previous_tag() end,
		{description = "move client to previous tag", group = "tag"}),
	awful.key({ modkey, altkey }, "l", function(c) move_to_next_tag() end,
		{description = "move cliet to next tag", group = "tag"}),

	-- Restart Awesome and Quit Awesome
	awful.key({ modkey, "Shift" }, "r", awesome.restart,
		{description = "reload awesome", group = "awesome"}),
	awful.key({ modkey, "Shift" }, "q", awesome.quit,
		{description = "quit awesome", group = "awesome"}),

	-- Increase "i" client width or "increase" in reverse
	awful.key({ altkey }, "i", function() awful.tag.incmwfact( 0.05) end,
		{description = "increase master width factor", group = "layout"}),
	awful.key({ modkey, altkey }, "i", function() awful.tag.incmwfact(-0.05) end,
		{description = "decrease master width factor", group = "layout"}),

	-- I use "l" for layout. I do not use this very often so no need to have both directions.
	awful.key({ modkey, "Control" }, "l", function() awful.layout.inc(1) end,
		{description = "select next", group = "layout"}),

	-- Show desktop. My function for this is above.
	awful.key({ altkey, "Control" }, "d", function(c) show_my_desktop() end,
		{description = "toggle showing the desktop", group = "client"}),

	-- Minimize and un-minimize clients
	awful.key({ modkey }, "n",
		function () if client.focus then client.focus.minimized = true end end,
		{description = "minimize", group = "client"}),
	awful.key({ modkey, "Control" }, "n",
		function()
			local c = awful.client.restore()
			-- Focus restored client
			if c then
				c:emit_signal(
					"request::activate", "key.unminimize", {raise = true}
				)
			end
		end,
		{description = "restore minimized", group = "client"}),

	-- Adjust client position
	awful.key({ modkey, altkey, "Control" }, "k", function() c = client.focus c.y = c.y - 15 end,
		{description = "adjust window up by 15px", group = "client"}),

	awful.key({ modkey, altkey, "Control" }, "j", function() c = client.focus c.y = c.y + 15 end,
		{description = "adjust window down by 15px", group = "client"}),

	awful.key({ modkey, altkey, "Control" }, "h", function() c = client.focus c.x = c.x - 15 end,
		{description = "adjust window left by 15px", group = "client"}),

	awful.key({ modkey, altkey, "Control" }, "l", function() c = client.focus c.x = c.x + 15 end,
		{description = "adjust window right by 15px", group = "client"}),

-- Launchers
	-- Terminal stuff
	-- The ones with rules needed to be put in a separate shell script because awful.spawn.with_shell does not work with rules.
	awful.key({ altkey, "Control" }, "t", function() awful.spawn(terminal) end,
		{description = "open a terminal", group = "launcher"}),

	awful.key({ altkey, "Control" }, "k", function() awful.spawn.with_shell(terminal.." -cd /home/brock/Desktop & sleep .2; xdotool key l l Return") end,
		{description = "Desktop directory", group = "launcher"}),

	awful.key({ altkey, "Control" }, "z", function() awful.spawn(terminal.." -e vi") end,
		{description = "Switch Keyboard", group = "utilities"}),

	awful.key({ "Control" }, "space", function() awful.spawn.with_shell(terminal.." -e bash -c 'ranger; bash'") end,
		{description = "Ranger", group = "launcher"}),

	awful.key({ modkey }, "space", function() awful.spawn("guake -t") end,
		{description = "toggle dropdown terminal", group = "launcher"}),

	awful.key({ altkey, "Control" }, "a", function() awful.spawn("agenda-launch", {screen = rt_one, tag = util}) end,
		{description = "Agenda", group = "launcher"}),

	awful.key({ modkey, "Control" }, "b", function() awful.spawn("blackboard", {screen = md_one, tag = mezc}) end,
		{description = "Blackboard", group = "launcher"}),

	awful.key({ altkey, "Control" }, "l", function() awful.spawn("lecciones-launch", {screen = 1, tag = util}) end,
		{description = "Lecciones", group = "launcher"}),

	awful.key({ altkey, "Control" }, "r", function() awful.spawn("urxvt -geometry 70x25 -T Reminder -e b-reminder", {floating = true, placement=function(c, args) args.margins = {right=200, bottom=200} return awful.placement.bottom_right(c, args) end, tag=function() return awful.screen.focused().selected_tag end}) end,
		{description = "Set reminder", group = "launcher"}),

	awful.key({ altkey, "Control" }, "1", function() bc_launch("today.txt", "urxvt -e bash -c 'nvim /home/brock/Nextcloud/today.txt'", {screen = rt_one, tag = util}) end,
		{description = "today.txt", group = "launcher"}),

	awful.key({ altkey, "Control" }, "2", function() bc_launch("today-personal.txt", "urxvt -e bash -c 'nvim /home/brock/Nextcloud/today-personal.txt'", {screen = rt_one, tag = util}) end,
		{description = "today-personal.txt", group = "launcher"}),

	awful.key({ altkey }, "space", function() cb_launch() end,
		{description = "clipboard", group = "launcher"}),

	-- Firefox personal
 	awful.key({ altkey, "Control" }, "b", function() awful.spawn("firefox") end,
 		{description = "Firefox", group = "launcher"}),

	awful.key({ altkey, "Control" }, "y", function() firefox_launch("https://youtube.com") end,
		{description = "YouTube", group = "launcher"}),

	awful.key({ modkey, "Shift" }, "m", function() awful.spawn("merge-firefox-windows") end,
	 	{description = "merge Firefox windows", group = "launcher"}),

	awful.key({ altkey, "Control" }, "e", function() firefox_launch(personal_email1) end,
		{description = "Personal Email", group = "launcher"}),

	awful.key({ modkey, "Control" }, "e", function() firefox_launch(personal_email2) end,
		{description = "Personal Email", group = "launcher"}),

	awful.key({ modkey, altkey, "Control" }, "m", function() firefox_launch(nextcloud_talk) end,
		{description = "Nextcloud Talk", group = "launcher"}),

	awful.key({ altkey, "Control" }, "m", function() firefox_launch(sms_app) end,
		{description = "Text Messaging", group = "launcher"}),

	awful.key({ modkey, "Control" }, "t", function() firefox_launch("https://web.telegram.org") end,
		{description = "Telegram", group = "launcher"}),

	awful.key({ altkey, "Control" }, "g", function() firefox_launch(course_website_206) end,
		{description = "Text Messaging", group = "launcher"}),

	-- Firefox work
	awful.key({ altkey, "Control" }, "6", function() firefox_launch(canvas) end,
		{description = "Canvas", group = "launcher"}),

	awful.key({ altkey, "Control" }, "j", function() firefox_launch(course_website) end,
		{description = "cochranb.com", group = "launcher"}),

	awful.key({ altkey, "Control" }, "3", function() firefox_launch(syllabus_102_ql) end,
		{description = "SPA 101 QLC Syllabus", group = "launcher"}),

	awful.key({ altkey, "Control" }, "4", function() firefox_launch(syllabus_102_1b) end,
		{description = "SPA 102 1C Syllabus", group = "launcher"}),

	awful.key({ altkey, "Control" }, "5", function() firefox_launch(syllabus_201_1c) end,
		{description = "SPA 102 QL Syllabus", group = "launcher"}),

	awful.key({ altkey, "Control" }, "h", function() firefox_launch(course_website_214) end,
		{description = "video site 102", group = "launcher"}),

	awful.key({ altkey, "Control" }, "u", function() firefox_launch(work_email) end,
		{description = "Work Email", group = "launcher"}),

	-- Calendar
	awful.key({ altkey, "Control" }, "7", function() cal_notify("cal") end,
		{description = "Show month calendar", group = "utilities"}),

	awful.key({ altkey, "Control" }, "8", function() cal_notify("cal -A 2") end,
		{description = "Show three month calendar", group = "utilities"}),

	awful.key({ altkey, "Control" }, "9", function() cal_notify("cal "..yr) end,
		{description = "Show year calendar", group = "utilities"}),

	awful.key({ altkey, "Control" }, "0", function() naughty.destroy_all_notifications() end,
		{description = "Kill all notifications", group = "utilities"}),

	-- Dictionaries
 	awful.key({ altkey, "Control" }, "w", function() diccionario_launch() end,
		{description = "WordReference", group = "launcher"}),

 	awful.key({ altkey, "Control" }, "o", function() awful.spawn("wordref-launch", {screen = rt_one, tag = pala}) end,
 		{description = "Cambridge", group = "launcher"}),

	awful.key({ altkey, "Control" }, "p", function() bc_launch("Real Academia Española", "urxvt -T 'Real Academia Española' -e rae", {screen = rt_one, tag = pala}) end,
		{description = "RAE", group = "launcher"}),

	awful.key({ altkey, "Control" }, "i", function() bc_launch("The Free Dictionary", "urxvt -T 'The Free Dictionary' -e tfd", {screen = rt_one, tag = pala}) end,
		{description = "TFD", group = "launcher"}),

	-- Miscellaneous
	awful.key({ altkey, "Control" }, "c", function() bc_launch("SpeedCrunch", "speedcrunch", {ontop = true, floating = true, placement = awful.placement.centered}) end,
		{description = "SpeedCrunch", group = "launcher"}),

-- Utilities, i.e. background stuff, not window launching
	awful.key({ altkey, "Control" }, "s", function() awful.spawn("xfce4-screenshot") end,
		{description = "Screenshot", group = "launcher"}),

	awful.key({ }, "Insert", function() awful.spawn("echo") end,
		{description = "disable Insert key by itself", group = "launcher"}),

	awful.key({ modkey }, "Return", function() awful.spawn("dmenu_run -l 10 -nb '#333333' -nf '#fcfcfc' -sb '#85492e' -sf '#fcfcfc'") end,
		{description = "dmenu prompt", group = "launcher"}),

	awful.key({ }, "F11", function() awful.spawn.with_shell("pgrep -u brock redshift-gtk || redshift-gtk") end,
		{description = "Redshift gtk", group = "utilities"}),

	awful.key({ }, "F12", function() awful.spawn("screenlock") end,
		{description = "Lock Screen", group = "utilities"}),

	-- Volume adjustment
	awful.key({ }, "XF86AudioRaiseVolume", function() awful.spawn("volumen -u") end,
		{description = "Volume up", group = "utilities"}),

	awful.key({ }, "XF86AudioLowerVolume", function() awful.spawn("volumen -d") end,
		{description = "Volume down", group = "utilities"}),

	awful.key({ }, "XF86AudioMute", function() awful.spawn("volumen -t") end,
		{description = "Volume toggle", group = "utilities"}),

	-- Digital cards to call on students
	-- awful.key({ }, "Print", function() awful.spawn("tarjetas 101") end,
	-- 	{description = "Tarjetas 101", group = "utilities"}),

	awful.key({ }, "Scroll_Lock", function() awful.spawn("tarjetas 102") end,
		{description = "Tarjetas 102", group = "utilities"}),

	awful.key({ }, "Pause", function() awful.spawn("tarjetas 201") end,
		{description = "Tarjetas 201", group = "utilities"}),

	-- Screen brightness
	awful.key({ }, "XF86MonBrightnessUp", function() awful.spawn("brightness -u") end,
		{description = "Increase brightness", group = "utilities"}),

	awful.key({ }, "XF86MonBrightnessDown", function() awful.spawn("brightness -d") end,
		{description = "Decrease brightness", group = "utilities"})
)

-- If I close the last client on a given tag, it will automatically switch to a tag that has a client. That is, there is no reason to stay on a tag that is empty.
client.connect_signal("unmanage", function(c)
	local t = c.first_tag or awful.screen.focused().selected_tag
	for _, cl in ipairs(t:clients()) do
		if cl ~= c then
			return
		end
	end
	for _, t in ipairs(awful.screen.focused().tags) do
		if #t:clients() > 0 then
			t:view_only()
			return
		end
	end
end)

move_client_to_screen = function(c, s)
	-- This must be reset since the last time this was run.
	first_client_on_screen, singular_client_on_tag, two_or_greater_clients = false, false, false

	-- Get the current tag.
	local t = c.first_tag or awful.screen.focused().selected_tag

	-- Cycle through all clients on the current tag. If there are two or greater clients on the current tag then skip next part
	for _, cl in ipairs(t:clients()) do
		if cl ~= c then
			two_or_greater_clients = true
			break
		end
	end

	if two_or_greater_clients == false then
		-- Since the following is running, then this means that the current tag has just one client.
		singular_client_on_tag = true
		-- print("singular_client_on_tag")

		-- Cycle through all tags on current screen. Then cycle through all clients on each tag. If the current client is the first on the screen, then set variable.
		inner_loop_run = false
		for _, tg in ipairs(awful.screen.focused().tags) do
			for _, cli in ipairs(tg:clients()) do
				if inner_loop_run then break end
				if cli == c then
					first_client_on_screen = true
					-- print("first_client_on_screen")
				end
				inner_loop_run = true
			end
			-- On the screen from which you are moving the client, move to the lowest index tag that has at least one client on it. You must ignore the current tag which has a client on it at this point in time because it has not been moved yet.
			if tg ~= t then
				if #tg:clients() > 0 then
					tg:view_only()
					break
				end
			end
		end
	end

	-- Move client to new screen but also keep it on the same tag index on the new screen.
	local index = c.first_tag.index
	c:move_to_screen(s)
	local tag = c.screen.tags[index]
	c:move_to_tag(tag)
	tag:view_only()

	-- This brings the focus to the client with the mouse under it. Focus gets lost if it is a singular client on the tag and it is the first tag in the list of tags with a client on them.
	if first_client_on_screen and singular_client_on_tag then
		function focus_client_under_mouse()
			gears.timer({
				timeout = 0.1,
				autostart = true,
				single_shot = true,
				callback =  function()
					local n = mouse.object_under_pointer()
						if n ~= nil and n ~= client.focus then
							client.focus = n
						end
					end
			})
		end
		focus_client_under_mouse()
		-- print("It is both the first client on the screen and the only client on that tag.\n")
	end
end

clientkeys = gears.table.join(
	awful.key({ modkey }, "c", function (c) c:kill() end,
		{description = "close", group = "client"}),

	awful.key({ modkey, "Shift" }, "h", function (c) move_client_to_screen(c, c.screen.index-1) end,
		{description = "move client one screen left", group = "client"}),

	awful.key({ modkey, "Shift" }, "l", function (c) move_client_to_screen(c, c.screen.index+1) end,
		{description = "move client one screen right", group = "client"}),

	awful.key({ modkey }, "f", awful.client.floating.toggle,
		{description = "toggle floating", group = "client"}),

	awful.key({ modkey }, "t", function (c) c.ontop = not c.ontop end,
		{description = "toggle keep on top", group = "client"}),

	awful.key({ modkey }, "m", function (c) c.maximized = not c.maximized c:raise() end,
		{description = "(un)maximize", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
	globalkeys = gears.table.join(globalkeys,
	-- View tag only.
	awful.key({ modkey }, "#" .. i + 9,
		function()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
				tag:view_only()
			end
		end,
	{description = "view tag #"..i, group = "tag"}),

	-- Move client to tag and follow focus there.
	awful.key({ modkey, "Shift" }, "#" .. i + 9,
		function()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:move_to_tag(tag)
				end
			end
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
				tag:view_only()
			end
		end,
		{description = "move focused client to tag # and follow focus to that tag "..i, group = "tag"})
	)
end

clientbuttons = gears.table.join(
	awful.button({ }, 1, function (c)
		c:emit_signal("request::activate", "mouse_click", {raise = true})
	end),
	awful.button({ modkey }, 1, function (c)
		c:emit_signal("request::activate", "mouse_click", {raise = true})
		awful.mouse.client.move(c)
	end),
	awful.button({ modkey }, 3, function (c)
		c:emit_signal("request::activate", "mouse_click", {raise = true})
		awful.mouse.client.resize(c)
	end)
)

-- Set keys
root.keys(globalkeys)

-- Use: xprop | grep -i 'class'
-- Rules
-- Rules to apply to new clients (through the "manage" signal).
-- size_hints_honor = false, -- This fixes my terminal gap issue when tiled.
awful.rules.rules = {
	-- All clients will match this rule.
	{ rule = { },
		properties = { border_width = beautiful.border_width,
			border_color = beautiful.border_normal,
			focus = awful.client.focus.filter,
			raise = true,
			keys = clientkeys,
			buttons = clientbuttons,
			screen = awful.screen.preferred,
			size_hints_honor = false,
			placement = awful.placement.no_overlap+awful.placement.no_offscreen
		}
	},

	-- Floating clients.
	{ rule_any = {
		class = { "Arandr", "Gpick", "SpeedCrunch" },
		-- xev
		name = { "Event Tester" }, }, properties = { floating = true }},

	{ rule = { class = "Atril" },
	properties = { tag = vari } },

	{ rule = { class = "Audacity" },
	properties = { tag = vari } },

	{ rule = { class = "Chromium" },
	properties = { tag = nave } },

	{ rule = { class = "Eom" },
	properties = { tag = vari } },

	{ rule = { class = "firefox" },
	properties = { tag = nave } },

	{ rule = { class = "Firefox-esr" },
	properties = { tag = nave } },

	{ rule = { class = "Gimp" },
	properties = { tag = vari } },

	{ rule = { class = "GParted" },
	properties = { tag = vari } },

	{ rule = { class = "guvcview" },
	properties = { floating = true, sticky = true } },

	{ rule = { class = "krita" },
	properties = { screen = 1, tag = vari } },

	-- Libreoffice, works for loimpress but not localc
	{ rule = { class = "Soffice" },
	properties = { tag = vari } },

	{ rule = { class = "SpeedCrunch" },
	properties = { ontop = true } },

	{ rule = { class = "Lxterminal" },
	properties = { tag = term } },

	{ rule = { class = "MPlayer" },
	properties = { floating = true, x = 1280, y = 600, screen = md_one, sticky = true } },

	{ rule = { class = "mpv" },
	properties = { floating = true, tag = vari } },

	{ rule = { class = "Pavucontrol" },
	properties = { screen = rt_one, tag = vari } },

	{ rule = { class = "SeaMonkey" },
	properties = { screen = rt_one, tag = pala } },

	{ rule = { class = "Thunar" },
	properties = { tag = vari, screen = 1 } },

	{ rule = { class = "URxvt" },
	properties = { tag = term } },

	{ rule = { class = "Guake" },
	properties = { floating = true } },

	{ rule = { class = "zoom" },
	properties = { tag = vari } }
}

-- Signals
-- Focus urgent clients automatically
-- When I launch a client at a particular place, I want to go to that client.
client.connect_signal("property::urgent", function(c)
	c.minimized = false
	c:jump_to()
end)

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
	-- Set the windows at the slave,
	-- i.e. put it at the end of others instead of setting it master.
	-- if not awesome.startup then awful.client.setslave(c) end
	if awesome.startup
		and not c.size_hints.user_position
		and not c.size_hints.program_position then
		-- Prevent clients from being unreachable after screen count changes.
		awful.placement.no_offscreen(c)
	end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
	c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

-- My focus border matches the mouse color.
client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- Autostart Applications
if mylaptop or thinkpad then
	awful.spawn("nm-applet")
end

awful.spawn.with_shell("pgrep copyq || copyq")
awful.spawn("xrdb .Xdefaults")
awful.spawn("fix-permissions-issue-with-bin")
awful.spawn("login-notify-send")
awful.spawn("ncloud")
awful.spawn.with_shell("pgrep guake || guake")
awful.spawn("no-empty-tags")

