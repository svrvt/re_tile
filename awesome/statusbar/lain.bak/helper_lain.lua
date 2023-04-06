-- {{{ Required libraries
-- Standard awesome library
local awful     = require("awful")
local beautiful = require("beautiful")

-- Wibox handling library
local wibox = require("wibox")
local lain  = require("lain")

-- Custom Local Library
require("statusbar.lain.lain")
local gmc = require("themes.gmc")
-- }}}

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

function WB.add_widgets_main (s)
  return {
    layout = wibox.layout.fixed.horizontal,
--    RC.launcher,
--    s.taglist,
    WB.ar_lr_pre,
    s.promptbox,
    WB.ar_lr_post
  }
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function WB.add_widgets_monitor_left (line, s)
  local cws = clone_widget_set
  local cis = clone_icon_set

  return {
    layout = wibox.layout.fixed.horizontal,

    --  time
    WB.arrow_rd,
    cis.clock,   cws.textclock,

    --  net
    WB.arrow_dr,  WB.arrow_rd,
    cis.netdown, cws.netdowninfo,
    cis.netup,   cws.netupinfo,

    --  mem, cpu, files system, temp, batt
    WB.arrow_dr,  WB.arrow_rd,
    cis.mem,     cws.mem,
    cis.cpu,     cws.cpu,
    cis.fs,      cws.fs,
--  cis.temp,    cws.temp,
    cis.bat,     cws.bat,
    
    --  wheather
    WB.arrow_dr,  WB.arrow_rd,
    cis.weather, cws.weather,

    --  mpd
    WB.arrow_dr,  WB.arrow_rd,
    cis.volume,  cws.volume,
    cis.mpd,     cws.mpd,

    -- at last   , you can ignore this line below
    WB.spacer,
  }
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function WB.add_widgets_monitor_right (line, s)
  local cws = clone_widget_set
  local cis = clone_icon_set

  return {
    layout = wibox.layout.fixed.horizontal,

    --  volume
    WB.arrow_dl,         WB.arrow_ld,
    cis.volume_dynamic,  cws.volumewidget,
    
    --  disk
    WB.arrow_dl,         WB.arrow_ld,
    cis.disk,           cws.disk_bar_widget,

    --  battery
    WB.arrow_dl,         WB.arrow_ld,
    cis.battery,        cws.battery_bar_widget,

    -- at last
    WB.arrow_dl
  }
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function WB.generate_wibox_two (s)
  -- layout: l_left, l_mid, tasklist

  -- Create the wibox
  s.wibox_two = awful.wibar({ position = "bottom", screen = s })

  -- Add widgets to the wibox
  s.wibox_two:setup {
    layout = wibox.layout.align.horizontal,
    WB.add_widgets_monitor_left (s),
    WB.spacer,
    WB.add_widgets_monitor_right (s),
  }
end
