-- {{{ Required libraries
-- Standard awesome library
local awful     = require("awful")
local beautiful = require("beautiful")

-- Wibox handling library
local wibox = require("wibox")
local lain  = require("lain")

-- Custom Local Library
require("statusbar.arrow.lain")
local gmc = require("themes.gmc")
-- }}}

-- Separators lain
local separators  = lain.util.separators

-- shortcuts
local setbg = wibox.widget.background
local setar = separators.arrow_right
local setal = separators.arrow_left

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local WB = wibox_package

-- Create a textclock widget
mytextclock = wibox.widget.textclock()

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function WB.add_widgets_top_left (s)
  return { -- Left widgets
    layout = wibox.layout.fixed.horizontal,
    RC.launcher,
    WB.spacer,
    s.taglist,
    WB.spacer,
    WB.arrow_dr,  WB.arrow_rd,
    WB.spacer,
    s.promptbox,
  }
end

function WB.add_widgets_top_right (s)
  local cws = clone_widget_set
  local cis = clone_icon_set

  return { -- Right widgets
    layout = wibox.layout.fixed.horizontal,

    --setar("alpha",             gmc.color['blue500']),
    --setbg(cis.weather,         gmc.color['blue500']),
    --setbg(cws.weather,         gmc.color['blue500']),
    --setar(gmc.color['blue500'], "alpha"),

    --  progressbar
    cis.volume_dynamic,  cws.volumewidget,
    cis.disk,            cws.disk_bar_widget,
    cis.battery,         cws.battery_bar_widget,

    -- default
    WB.arrow_dl,         WB.arrow_ld,
    mykeyboardlayout,
    wibox.widget.systray(),
    mytextclock,
    s.layoutbox,
  }
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function WB.generate_wibox_one (s)
  -- layout: l_left, nil, l_right

  -- Create the wibox
  s.wibox_top_top = awful.wibar({ position = "top", screen = s, height = "24" })

  -- Add widgets to the wibox
  s.wibox_top_top:setup {
    layout = wibox.layout.align.horizontal,
    WB.add_widgets_top_left (s),
    nil,
    WB.add_widgets_top_right (s),
  }
end

function WB.generate_wibox_tasklist (s)
  -- layout: tasklist

  -- Create the wibox
  s.wibox_top_bottom = awful.wibar({
    position = "bottom",
    screen = s,
    height = "20",
    widget = s.tasklist
  })
end
