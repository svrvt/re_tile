--[[
     Original Source Modified From: github.com/copycat-killer
     https://github.com/copycat-killer/awesome-copycats/blob/master/rc.lua.multicolor
--]]

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Standard awesome library
local awful     = require("awful")
local beautiful = require("beautiful")

-- Wibox handling library
local wibox = require("wibox")
local lain = require("lain")

-- Custom Local Library
local gmc = require("themes.gmc")

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local W = {}
clone_widget_set = W           -- object name

local I = {}
clone_icon_set = I             -- object name

-- split module, to make each file shorter,
-- all must have same package name

-- global for all splited
markup      = lain.util.markup

-- progress bar related widgets -- after global markup
local config_path = awful.util.getdir("config") .. "statusbar/arrow/"
dofile(config_path .. "lain-diskfree.lua")
dofile(config_path .. "lain-battery.lua")
dofile(config_path .. "lain-sound.lua")
dofile(config_path .. "custom.lua")

local fg_color = gmc.color['white']
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- MEM
I.mem = wibox.widget.imagebox(beautiful.widget_mem)
W.mem = wibox.widget.textbox()
W.update_mem = lain.widget.mem({
  settings = function()
    W.mem:set_markup(markup(fg_color, mem_now.used .. "M "))
  end
})

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- CPU
I.cpu = wibox.widget.imagebox()
I.cpu:set_image(beautiful.widget_cpu)
W.cpu = wibox.widget.textbox()

W.update_cpu = lain.widget.cpu({
  settings = function()
    W.cpu:set_markup(markup(fg_color, cpu_now.usage .. "% "))
  end
})

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Coretemp
I.temp = wibox.widget.imagebox(beautiful.widget_temp)
W.temp = wibox.widget.textbox()

W.update_temp = lain.widget.temp({
  settings = function()
    W.temp:set_markup(markup(fg_color, coretemp_now .. "°C "))
  end
})

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Textclock
I.clock = wibox.widget.imagebox(beautiful.widget_clock)

W.textclock = awful.widget.textclock(
  markup(gmc.color['blue900'], "%A %d %B ")
    .. markup(gmc.color['black'], ">")
    .. markup(gmc.color['green900'], " %H:%M "))

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Calendar

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Weather
I.weather = wibox.widget.imagebox(beautiful.widget_weather)
W.weather = wibox.widget.textbox()

W.update_weather = lain.widget.weather({
  city_id = 1642911, -- http://openweathermap.org/city/1642911
  settings = function()
    descr = weather_now["weather"][1]["description"]:lower()
    units = math.floor(weather_now["main"]["temp"])
    W.weather:set_markup(markup(fg_color, descr .. " @ " .. units .. "°C "))
  end
})

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Net
I.netdown = wibox.widget.imagebox(beautiful.widget_netdown)
--netdownicon.align = "middle"

W.netdowninfo = wibox.widget.textbox()
W.netupinfo   = wibox.widget.textbox()

I.netup = wibox.widget.imagebox(beautiful.widget_netup)
--netupicon.align = "middle"

W.update_net = lain.widget.net({
  settings = function()
    W.netupinfo:set_markup(markup(fg_color, net_now.sent .. " "))
    W.netdowninfo:set_markup(markup(fg_color, net_now.received .. " "))
  end
})
