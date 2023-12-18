-- {{{ Required libraries
-- Standard awesome library
local awful = require("awful")
-- local beautiful  = require("beautiful")

-- local connman = require("connman_widget")
-- set the GUI client.
-- connman.gui_client = "cmst"

-- Wibox handling library
local wibox = require("wibox")

-- local gears = require('gears')
-- local round_rect = function(cr, w, h)
--     gears.shape.rounded_rect(cr, w, h, 10)
-- end

-- local mpdarc_widget = require("awesome-wm-widgets.mpdarc-widget.mpdarc")
local volume_widget = require("awesome-wm-widgets.volume-widget.volume")
-- local volume_widget = require('awesome-wm-widgets.pactl-widget.volume')
-- local logout_popup = require("awesome-wm-widgets.logout-popup-widget.logout-popup")
-- local cpu_widget = require("awesome-wm-widgets.cpu-widget.cpu-widget")
-- local docker_widget = require("awesome-wm-widgets.docker-widget.docker")
-- local calendar_widget = require("awesome-wm-widgets.calendar-widget.calendar")
-- local fs_widget = require("awesome-wm-widgets.fs-widget.fs-widget")
-- local github_contributions_widget = require("awesome-wm-widgets.github-contributions-widget.github-contributions-widget")
-- local ram_widget = require("awesome-wm-widgets.ram-widget.ram-widget")
local word_clock = require("awesome-wm-widgets.word-clock-widget.word-clock")
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local WB = wibox_package

-- Create a textclock widget
mytextclock = wibox.widget.textclock()

-- local cw = calendar_widget({
--     -- theme = 'outrun', 'dark','light','naughty (default)',
--     placement = 'bottom_left',
--     start_sunday = false,
--     radius = 8,
-- -- with customized next/previous (see table above)
--     previous_month_button = 4,
--     next_month_button = 5,
-- })

-- mytextclock:connect_signal("button::press",
--     function(_, _, _, button)
--         if button == 1 then cw.toggle() end
--     end)

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function WB.add_widgets_left(s)
	return {
		-- Left widgets
		layout = wibox.layout.fixed.horizontal,
		-- RC.launcher,
		s.taglist,
		-- wibox.widget.textbox(" | "),
		s.promptbox,
	}
end

function WB.add_widgets_middle(s)
	return s.tasklist -- Middle widget
end

function WB.add_widgets_right(s)
	return {
		-- Right widgets
		layout = wibox.layout.fixed.horizontal,
		mykeyboardlayout,
		-- mpdarc_widget,
		wibox.widget.systray(),
		-- docker_widget{
		--     -- number_of_containers = 5
		-- },
		-- connman, -- <- connman widget
		volume_widget({
			--https://pavelmakhov.com/awesome-wm-widgets/
			--horizontal_bar, vertical_bar, icon,icon_and_text, arc
			widget_type = "vertical_bar",
		}),
		-- github_contributions_widget({
		--     username = 'RU927',
		--     days = 180,
		--     color_of_empty_cells = '#575025cc',
		--     theme = 'leftpad', --'pink','dracula','leftpad','teal','classic','standard',
		--     margin_top = 1,
		--     with_border = false
		-- }),
		-- mytextclock,
		-- logout_popup.widget{},
		word_clock({
			-- font = 'Carter One 12',
			accent_color = "#a32822",
			main_color = "#d1c381",
			is_human_readable = true,
			military_time = true,
			with_spaces = false,
		}),
		s.layoutbox,
	}
end

function WB.add_widgets_buttom_l(s)
	return {
		layout = wibox.layout.fixed.horizontal,
		RC.launcher,
		mytextclock,
	}
end

function WB.add_widgets_buttom_r(s)
	return {
		layout = wibox.layout.fixed.horizontal,
		--     fs_widget({
		--     mounts = { '/' },
		--     timeout = 3600
		-- }),
		-- ram_widget({
		--     color_used = beautiful.bg_image_urgent,
		--     color_free = beautiful.fg_normal,
		--     color_buf	= beautiful.border_color_active,
		--     widget_height	= 25,
		--     widget_show_buf =	true,
		--     timeout	= 10
		-- }),
		-- cpu_widget({
		--     width = 70,
		--     step_width = 2,
		--     step_spacing = 1,
		--     -- color = '#434c5e',
		--     enable_kill_button = true,
		--     process_info_max_length = -1,
		--     timeout = 1
		-- }),
	}
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function WB.generate_wibox_one(s)
	-- layout: l_left, tasklist, l_right

	-- Create the wibox
	s.wibox_top = awful.wibar({
		position = "top",
		screen = s,
		height = 23,
		border_width = 4,
		opacity = 0.9,
		-- shape = round_rect,
	})

	-- Add widgets to the wibox
	s.wibox_top:setup({
		layout = wibox.layout.align.horizontal,
		WB.add_widgets_left(s),
		WB.add_widgets_middle(s),
		WB.add_widgets_right(s),
	})
end

function WB.generate_wibox_two(s)
	-- layout: l_left, l_mid, tasklist

	-- Create the wibox
	s.wibox_two = awful.wibar({ position = "bottom", screen = s, height = 16 })

	-- Add widgets to the wibox
	s.wibox_two:setup({
		layout = wibox.layout.align.horizontal,
		WB.add_widgets_buttom_l(s),
		-- WB.add_widgets_bottom_m(s),
		WB.add_widgets_buttom_r(s),
	})
end
