-- {{{ Required libraries
-- Standard awesome library
local awful     = require("awful")
local beautiful = require("beautiful")

local wibox = require("wibox")
local lain  = require("lain")

-- Custom Local Library
local gmc = require("themes.gmc")
-- }}}

-- Separators lain
local separators  = lain.util.separators

-- shortcuts
local setbg = wibox.widget.background
local setar = separators.arrow_right
local setal = separators.arrow_left
local cws   = clone_widget_set
local cis   = clone_icon_set
  
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
    WB.spacer,
    setar("alpha",              gmc.color['blue200']),
    setar(gmc.color['blue200'], gmc.color['blue300']),
    setbg(cis.netdown,          gmc.color['blue300']),
    setbg(cws.netdowninfo,      gmc.color['blue300']),
    setar(gmc.color['blue300'], gmc.color['blue500']),
    setbg(cis.netup,            gmc.color['blue500']),
    setbg(cws.netupinfo,        gmc.color['blue500']),
    setar(gmc.color['blue500'], gmc.color['blue700']),
    setbg(cis.mem,              gmc.color['blue700']),
    setbg(cws.mem,              gmc.color['blue700']),
    setar(gmc.color['blue700'], gmc.color['blue900']),
    setbg(cis.cpu,              gmc.color['blue900']),
    setbg(cws.cpu,              gmc.color['blue900']),
    setal(gmc.color['blue900'], gmc.color['blue700']),
    setbg(cis.fs,               gmc.color['blue700']),
    setbg(cws.fs,               gmc.color['blue700']),
    setal(gmc.color['blue700'], gmc.color['blue500']),
    setbg(cis.temp,             gmc.color['blue500']),
    setbg(cws.temp,             gmc.color['blue500']),
    setal(gmc.color['blue500'], gmc.color['blue300']),
    setbg(cis.bat,              gmc.color['blue300']),
    setbg(cws.bat,              gmc.color['blue300']),
    setal(gmc.color['blue300'], gmc.color['blue200']),
    setal(gmc.color['blue200'], "alpha"),
    WB.spacer,
  }
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function WB.add_widgets_monitor_right (line, s)
  return {
    layout = wibox.layout.fixed.horizontal,
    WB.arrow_dl,         WB.arrow_ld,
    WB.spacer,
    cis.volume,  cws.volume,
    cis.mpd,     cws.mpd,
    WB.spacer,
    WB.arrow_dl,         WB.arrow_ld,
    cis.uptime,          cws.uptime,
    WB.spacerline,
    WB.arrow_dl,
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
    nil,
    WB.add_widgets_monitor_right (s),
  }
end
