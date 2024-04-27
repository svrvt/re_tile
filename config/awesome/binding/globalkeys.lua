-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
-- local hotkeys_popup = require("awful.hotkeys_popup").widget
-- Включение виджета помощи по горячим клавишам для VIM
-- и других приложений при открытии клиента с соответствующим именем:
local hotkeys_popup = require("awful.hotkeys_popup")
-- Menubar library
local menubar = require("menubar")

-- Resource Configuration
local browser = RC.vars.browser

local terminal = RC.vars.terminal
local fm_cmd = terminal .. " -e " .. RC.vars.fm
local editor_cmd = terminal .. " -e " .. RC.vars.editor

local runner = RC.vars.runner
local runner_all = RC.vars.runner_all
local buf_chng = RC.vars.buf_chng
local runner2 = RC.vars.runner2

local modkey = RC.vars.modkey
local altkey = RC.vars.altkey

local volume_widget = require("awesome-wm-widgets.volume-widget.volume")
local logout_popup = require("awesome-wm-widgets.logout-popup-widget.logout-popup")

local _M = {}

-- reading
-- https://awesomewm.org/wiki/Global_Keybindings

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function _M.get()
	local globalkeys = gears.table.join(
		awful.key({ modkey }, "i", function()
			logout_popup.launch()
		end, { description = "Show logout screen", group = "custom" }),

		awful.key({}, "XF86AudioRaiseVolume", function()
			volume_widget:inc(5)
		end),
		awful.key({}, "XF86AudioLowerVolume", function()
			volume_widget:dec(5)
		end),
		awful.key({}, "XF86AudioMute", function()
			volume_widget:toggle()
		end),

		awful.key({ modkey }, "s", hotkeys_popup.show_help, { description = "show help", group = "awesome" }),
		awful.key({ modkey }, "w", function()
			mymainmenu:show()
		end, { description = "вызов главного меню", group = "awesome" }),
		--   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		-- переключение тега
		awful.key({ modkey }, "Left", awful.tag.viewprev, { description = "view previous", group = "tag" }),
		awful.key({ modkey }, "Right", awful.tag.viewnext, { description = "view next", group = "tag" }),
		awful.key({ modkey }, "Escape", awful.tag.history.restore, { description = "go back", group = "tag" }),
		--   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		awful.key(
			{ modkey },
			"u",
			awful.client.urgent.jumpto,
			{ description = "jump to urgent client", group = "client" }
		),
		--   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		--   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		--brockcochranfunc
		-- Horizontal Vim navigation keys to go left and right on tags.
		-- awful.key({ "Mod1" }, "h", function() view_prev_tag_with_client() end,
		--   {description = "view previous", group = "tag"}),
		-- awful.key({ "Mod1" }, "l", function() view_next_tag_with_client() end,
		--   {description = "view next tag with client on it", group = "tag"}),
		-- Horizontal Vim navigation keys to move the client to the next or previous tag and follow there
		-- awful.key({ modkey, "Mod1" }, "h", function(c) move_to_previous_tag() end,
		--   {description = "move client to previous tag", group = "tag"}),
		-- awful.key({ modkey, "Mod1" }, "l", function(c) move_to_next_tag() end,
		--   {description = "move cliet to next tag", group = "tag"}),
		--   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		--   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		--фокус монитора?
		---[[--
		-- awful.key({ modkey, "Control" }, "j", function()
		awful.key({ "Control", "Shift" }, "Right", function()
			awful.screen.focus_relative(1)
		end, { description = "focus the next screen", group = "screen" }),

		-- awful.key({ modkey, "Control" }, "k", function()
		awful.key({ "Control", "Shift" }, "Left", function()
			awful.screen.focus_relative(-1)
		end, { description = "focus the previous screen", group = "screen" }),
		--]]
		--
		-- Фокус клиента
		awful.key({ modkey }, "Tab", function()
			awful.client.focus.history.previous()
			if client.focus then
				client.focus:raise()
			end
		end, { description = "go back", group = "client" }),
		awful.key({ modkey }, "j", function()
			awful.client.focus.byidx(1)
		end, { description = "фокус на след. клиент", group = "client" }),
		awful.key({ modkey }, "k", function()
			awful.client.focus.byidx(-1)
		end, { description = "фокус на пред. клиент", group = "client" }),
		--   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		-- Управление схемой расположения
		awful.key({ modkey, "Shift" }, "j", function()
			awful.client.swap.byidx(1)
		end, { description = "переставить окно со след. ", group = "client" }),
		awful.key({ modkey, "Shift" }, "k", function()
			awful.client.swap.byidx(-1)
		end, { description = "переставить окно с пред.", group = "client" }),
		awful.key({ modkey }, "h", function()
			awful.tag.incmwfact(-0.05)
		end, { description = "уменьшить мастер клиент", group = "layout" }),
		awful.key({ modkey }, "l", function()
			awful.tag.incmwfact(0.05)
		end, { description = "увеличить мастер клиент", group = "layout" }),
		awful.key({ modkey, "Shift" }, "h", function()
			awful.tag.incnmaster(1, nil, true)
		end, { description = "increase the number of master clients", group = "layout" }),
		awful.key({ modkey, "Shift" }, "l", function()
			awful.tag.incnmaster(-1, nil, true)
		end, { description = "decrease the number of master clients", group = "layout" }),
		-- awful.key({ modkey, "Control" }, "h", function() awful.tag.incncol(1, nil, true) end,
		--   { description = "increase the number of columns", group = "layout" }),
		-- awful.key({ modkey, "Control" }, "l", function() awful.tag.incncol( -1, nil, true) end,
		--   { description = "decrease the number of columns", group = "layout" }),
		awful.key({ modkey }, "space", function()
			awful.layout.inc(1)
		end, { description = "select next", group = "layout" }),
		awful.key({ modkey, "Shift" }, "space", function()
			awful.layout.inc(-1)
		end, { description = "select previous", group = "layout" }),

		awful.key({ modkey, "Control" }, "n", function()
			local c = awful.client.restore()
			-- Focus restored client
			if c then
				c:emit_signal("request::activate", "key.unminimize", { raise = true })
			end
		end, { description = "развернуть", group = "client" }),

		--   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		-- Стандартная программа
		-- Terminal
		awful.key({ modkey }, "Return", function()
			awful.spawn(terminal)
		end, { description = "терминал", group = "RU" }),
		-- Ranger
		awful.key({ modkey }, "r", function()
			awful.spawn(fm_cmd)
		end, { description = "файловый менеджер", group = "RU" }),
		-- Neovim
		awful.key({ modkey }, "v", function()
			awful.spawn(editor_cmd)
		end, { description = "текстовый редактор", group = "RU" }),

		-- rofi
		awful.key({ modkey }, "d", function()
			awful.spawn(runner)
		end, { description = "runner", group = "RU" }),

		awful.key({ modkey, "Shift" }, "d", function()
			awful.spawn(runner_all)
		end, { description = "runner all func", group = "RU" }),

		awful.key({ modkey }, "a", function()
			awful.spawn(buf_chng)
		end, { description = "буфер обмена", group = "RU" }),

		awful.key({ altkey }, "space", function()
			awful.spawn.with_shell(runner2, { floating = true })
		end, { description = "kde runner", group = "RU" }),
		-- Menubar
		awful.key({ modkey }, "p", function()
			menubar.show()
		end, { description = "menubar", group = "RU" }),
		-- Browser
		awful.key({ modkey }, "b", function()
			awful.util.spawn(browser)
		end, { description = "browser", group = "RU" }),
		--   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		-- Resize
		--awful.key({ modkey, "Control" }, "Left",  function () awful.client.moveresize( 20,  20, -40, -40) end),
		--awful.key({ modkey, "Control" }, "Right", function () awful.client.moveresize(-20, -20,  40,  40) end),
		awful.key({ modkey, "Control" }, "Down", function()
			awful.client.moveresize(0, 0, 0, -20)
		end),
		awful.key({ modkey, "Control" }, "Up", function()
			awful.client.moveresize(0, 0, 0, 20)
		end),
		awful.key({ modkey, "Control" }, "Left", function()
			awful.client.moveresize(0, 0, -20, 0)
		end),
		awful.key({ modkey, "Control" }, "Right", function()
			awful.client.moveresize(0, 0, 20, 0)
		end),

		-- Move
		awful.key({ modkey, "Shift" }, "Down", function()
			awful.client.moveresize(0, 20, 0, 0)
		end),
		awful.key({ modkey, "Shift" }, "Up", function()
			awful.client.moveresize(0, -20, 0, 0)
		end),
		awful.key({ modkey, "Shift" }, "Left", function()
			awful.client.moveresize(-20, 0, 0, 0)
		end),
		awful.key({ modkey, "Shift" }, "Right", function()
			awful.client.moveresize(20, 0, 0, 0)
		end),
		-- --
		awful.key(
			{ modkey, "Control" },
			"r",
			awesome.restart,
			{ description = "перезапуск awesome", group = "awesome" }
		),
		awful.key(
			{ modkey, "Control" },
			"q",
			awesome.quit,
			{ description = "выход из awesome", group = "awesome" }
		)

		--   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
	)

	return globalkeys
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return setmetatable({}, {
	__call = function(_, ...)
		return _M.get(...)
	end,
})
