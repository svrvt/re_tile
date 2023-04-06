--[[
     Original Source Modified From: github.com/copycat-killer
     https://github.com/copycat-killer/awesome-copycats/blob/master/rc.lua.copland
--]]

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Standard awesome library
local awful     = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")

local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

-- Wibox handling library
local wibox = require("wibox")
local lain = require("lain")

local W = clone_widget_set     -- object name
local I = clone_icon_set       -- object name

-- Custom Local Library
local gmc = require("themes.gmc")

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Battery from copycat-multicolor

I.bat = wibox.widget.imagebox(beautiful.widget_batt)
W.bat = wibox.widget.textbox()

W.update_bat = lain.widget.bat({
    settings = function()
        if bat_now.perc == "N/A" then
            perc = "AC "
        else
            perc = bat_now.perc .. "% "
        end
        W.bat:set_markup(markup(gmc.color['white'], perc))
    end
})

-- Battery from copycat-copland

I.battery = wibox.widget.imagebox(beautiful.monitor_bat)

W.battery_bar = wibox.widget {
    forced_height    = dpi(1),
    forced_width     = dpi(59),
    color            = theme.fg_normal,
    background_color = theme.bg_normal,
    margins          = 1,
    paddings         = 1,
    ticks            = true,
    ticks_size       = dpi(6),
    widget           = wibox.widget.progressbar,
}

W.battery_margin = wibox.layout.margin(W.battery_bar, 2, 7)
W.battery_margin:set_top(6)
W.battery_margin:set_bottom(9)

-- Update bar, also in widgets popups
local battery_widget_settings = function()
    if bat_now.status == "N/A" then return end

    perc = tonumber(bat_now.perc)
    if perc == nil then return end

    if bat_now.status == "Charging" then
        I.battery:set_image(beautiful.monitor_ac)
        if perc >= 98 then
            W.battery_bar:set_color(gmc.color['green300'])
        elseif perc > 50 then
            W.battery_bar:set_color(gmc.color['blue300'])
        elseif perc > 15 then
            W.battery_bar:set_color(beautiful.fg_normal)
        else
            W.battery_bar:set_color(gmc.color['red300'])
        end
    else
        if perc >= 98 then
            W.battery_bar:set_color(gmc.color['green300'])
        elseif perc > 50 then
            W.battery_bar:set_color(gmc.color['blue300'])
            I.battery:set_image(beautiful.monitor_bat)
        elseif perc > 15 then
            W.battery_bar:set_color(beautiful.fg_normal)
            I.battery:set_image(beautiful.monitor_bat_low)
        else
            W.battery_bar:set_color(gmc.color['red300'])
            I.battery:set_image(beautiful.monitor_bat_no)
        end
    end
    W.battery_bar:set_value(perc / 100)
end

W.battery_widget_update = lain.widget.bat({
    settings = battery_widget_settings
})

W.batbg = wibox.container.background(
  W.battery_bar, gmc.color['grey500'], gears.shape.rectangle)
W.battery_bar_widget = wibox.container.margin(
  W.batbg, dpi(2), dpi(7), dpi(6), dpi(6))
