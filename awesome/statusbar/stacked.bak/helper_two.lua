-- {{{ Required libraries
-- Standard awesome library
local awful     = require("awful")
local beautiful = require("beautiful")

local wibox = require("wibox")
local lain  = require("lain")

-- Custom Local Library
--require("statusbar.stacked.custom")
local gmc = require("themes.gmc")

-- progress bar related widgets -- after global markup
local config_path = awful.util.getdir("config") .. "statusbar/stacked/"
dofile(config_path .. "custom.lua")
-- }}}

-- Separators lain
local separators  = lain.util.separators

-- shortcuts
local setbg = wibox.widget.background
local setar = separators.arrow_right
local setal = separators.arrow_left
  
-- example
local icon_example = wibox.widget.imagebox(beautiful.widget_example)

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local WB = wibox_package

function WB.initdeco ()
    -- Spacer
    WB.spacer = wibox.widget.textbox(" ")
    WB.spacerline = wibox.widget.textbox(" | ")

    -- Separators lain
    local separators  = lain.util.separators
    local arrow_color = gmc.color['red300']
    WB.arrow_dl = separators.arrow_left("alpha", arrow_color)
    WB.arrow_ld = separators.arrow_left(arrow_color, "alpha")
    WB.arrow_dr = separators.arrow_right("alpha", arrow_color)
    WB.arrow_rd = separators.arrow_right(arrow_color, "alpha")
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function WB.add_widgets_monitor_left (line, s)
  return {
    layout = wibox.layout.fixed.horizontal,
    WB.arrow_rd,
    WB.spacerline,
    WB.arrow_dr,  WB.arrow_rd,
    WB.spacer,
    setar("alpha",              gmc.color['blue200']),
    setar(gmc.color['blue200'], gmc.color['blue300']),
    setbg(icon_example,         gmc.color['blue300']),
    setar(gmc.color['blue300'], gmc.color['blue500']),
    setbg(icon_example,         gmc.color['blue500']),
    setar(gmc.color['blue500'], gmc.color['blue700']),
    setbg(icon_example,         gmc.color['blue700']),
    setar(gmc.color['blue700'], gmc.color['blue900']),
    setar(gmc.color['blue900'], "alpha"),
    WB.spacer,
  }
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function WB.add_widgets_monitor_right (line, s)
  return {
    layout = wibox.layout.fixed.horizontal,
    setal("alpha", gmc.color['blue900']),
    setal(gmc.color['blue900'], gmc.color['blue700']),
    setbg(icon_example,         gmc.color['blue700']),
    setal(gmc.color['blue700'], gmc.color['blue500']),
    setbg(icon_example,         gmc.color['blue500']),
    setal(gmc.color['blue500'], gmc.color['blue300']),
    setbg(icon_example,         gmc.color['blue300']),
    setal(gmc.color['blue300'], gmc.color['blue200']),
    setal(gmc.color['blue200'], "alpha"),
    WB.spacer,
    WB.arrow_dl,         WB.arrow_ld,
    WB.spacerline,
    WB.arrow_dl,
  }
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function WB.add_widgets_monitor_middle (line, s)
  local cws   = clone_widget_set
  local cis   = clone_icon_set
  markup      = lain.util.markup

  return {
    layout = wibox.layout.fixed.horizontal,  
    cis.uptime,          cws.uptime,
  }
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function WB.generate_wibox_two (s)
  -- layout: l_left, nil, tasklist

  -- Create the wibox
  s.wibox_two = awful.wibar({ position = "bottom", screen = s })

  -- Add widgets to the wibox
  s.wibox_two:setup {
    layout = wibox.layout.align.horizontal,
    WB.add_widgets_monitor_left (s),
    WB.add_widgets_monitor_middle (s),
    WB.add_widgets_monitor_right (s),
  }
end
