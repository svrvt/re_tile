--[[
     Vicious Sample Widget Source Taken From:
     https://awesome.naquadah.org/wiki/Vicious#Example_widgets
--]]
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --


-- {{{ Required libraries
local awful     = require("awful")
local beautiful = require("beautiful")
local wibox     = require("wibox")
local vicious   = require("vicious")
local gmc       = require("themes.gmc")
-- }}}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local W         = {}
local F         = {} -- Format
local wlandev   = RC.vars.wlandev

local I         = {}
icon_set        = I -- object name

local T         = {}
text_label      = T -- object name

local function hlspan(text)
  return "<span color='" .. gmc.color['blue900'] .. "'>" .. text .. "</span>"
end

local function altspan(text)
  return "<span color='" .. gmc.color['yellow900'] .. "'>" .. text .. "</span>"
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

--  Network usage widget
-- Initialize widget, use widget({ type = "textbox" }) for awesome < 3.5
W.net = wibox.widget.textbox()
F.net = wlandev .. ": "
    .. "↓ " .. hlspan("${" .. wlandev .. " down_kb}") .. ", "
    .. "↑ " .. hlspan("${" .. wlandev .. " up_kb}")
-- Register widget
vicious.register(W.net, vicious.widgets.net, F.net, 3)

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

W.date = wibox.widget.textbox()
vicious.register(W.date, vicious.widgets.date, "%b %d, %R")

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

W.battery = wibox.widget.textbox()
F.battery = "Bat: " .. hlspan("$1$2")
vicious.register(W.battery, vicious.widgets.bat, F.battery, 67, "BAT0")

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

I.mem = wibox.widget.imagebox(beautiful.widget_mem)
T.mem = wibox.widget.textbox("Mem: ")
W.mem = wibox.widget.textbox()
F.mem = "Mem: " .. hlspan("$1%") .. " (" .. altspan("$2MB/$3MB") .. ")"
vicious.cache(vicious.widgets.mem)
vicious.register(W.mem, vicious.widgets.mem, F.mem, 13)

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

I.cpu = wibox.widget.imagebox()
I.cpu:set_image(beautiful.widget_cpu)
T.cpu = wibox.widget.textbox("CPU: ")

W.cpu = wibox.widget.textbox()
F.cpu = "CPU 1:" .. hlspan("$1%") .. ", "
    .. "CPU 2:" .. hlspan("$2%")
vicious.cache(vicious.widgets.cpu)
vicious.register(W.cpu, vicious.widgets.cpu, F.cpu, 17)

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- setuid in debian
-- sudo dpkg-reconfigure hddtemp

W.hddtemp = wibox.widget.textbox()
F.hddtemp = " HDD: " .. hlspan("${/dev/sda}°С")
vicious.register(W.hddtemp, vicious.widgets.hddtemp, F.hddtemp, 41, "7634")

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

W.mpd = wibox.widget.textbox()
wmpd = W.mpd
F.mpd = function(wmpd, args)
  if args["{state}"] == "Stop" then
    return " - "
  else
    return hlspan(args["{Artist}"]) .. ' - ' .. altspan(args["{Title}"])
  end
end

vicious.register(W.mpd, vicious.widgets.mpd, F.mpd, 10)

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

W.graph_cpu = awful.widget.graph()
W.graph_cpu:set_width(50)
W.graph_cpu:set_background_color(gmc.color['white'] .. "cc")
W.graph_cpu:set_color({
  type = "linear",
  from = { 0, 0 },
  to = { 50, 0 },
  stops = {
    { 0,   gmc.color['red900'] },
    { 0.5, gmc.color['yellow500'] },
    { 1,   gmc.color['blue900'] } }
})
vicious.cache(vicious.widgets.cpu)
vicious.register(W.graph_cpu, vicious.widgets.cpu, "$1", 7)

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

W.graph_mem = awful.widget.graph()
W.graph_mem:set_width(50)
W.graph_mem:set_background_color(gmc.color['white'] .. "cc")
W.graph_mem:set_color({
  type = "linear",
  from = { 0, 0 },
  to = { 50, 0 },
  stops = {
    { 0,   gmc.color['blue900'] },
    { 0.5, gmc.color['blue300'] },
    { 1,   gmc.color['blue500'] } }
})
vicious.cache(vicious.widgets.mem)
vicious.register(W.graph_mem, vicious.widgets.mem, "$1", 17)

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

W.progress_mem = wibox.widget.progressbar()

-- https://github.com/vicious-widgets/vicious

-- Create wibox with batwidget
membox = wibox.layout.margin(
  wibox.widget {
    {
      max_value        = 1,
      widget           = W.progress_mem,
      width            = 100,
      paddings         = 3,
      border_width     = 1,
      border_color     = gmc.color['blue900'],
      background_color = gmc.color['white'],
      color            = {
        type  = "linear",
        from  = { 0, 0 },
        to    = { 50, 0 },
        stops = {
          { 0,   gmc.color['blue900'] },
          { 0.5, gmc.color['blue300'] },
          { 1,   gmc.color['blue500'] }
        }
      }
    },
    {
      text   = 'Memory',
      widget = wibox.widget.textbox,
    },
    layout = wibox.layout.stack
  },
  1, 1, 3, 3)

-- Register widget
--vicious.cache(vicious.widgets.mem)
vicious.register(W.progress_mem, vicious.widgets.mem, "$1", 11)

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

W.progress_cpu = wibox.widget.progressbar()

-- https://github.com/vicious-widgets/vicious

-- Create wibox with batwidget
cpubox = wibox.layout.margin(
  wibox.widget {
    {
      max_value        = 1,
      widget           = W.progress_cpu,
      width            = 100,
      paddings         = 3,
      border_width     = 1,
      border_color     = gmc.color['blue900'],
      background_color = gmc.color['white'],
      color            = {
        type  = "linear",
        from  = { 0, 0 },
        to    = { 50, 0 },
        stops = {
          { 0,   gmc.color['yellow900'] },
          { 0.5, gmc.color['orange300'] },
          { 1,   gmc.color['red500'] }
        }
      }
    },
    {
      text   = 'Processor',
      widget = wibox.widget.textbox,
    },
    layout = wibox.layout.stack
  },
  1, 1, 3, 3)

-- Register widget
--vicious.cache(vicious.widgets.mem)
vicious.register(W.progress_cpu, vicious.widgets.cpu, "$1", 13)

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return W
