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

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- / fs

I.fs = wibox.widget.imagebox(beautiful.widget_fs)
W.fs = wibox.widget.textbox()

--
-- Can't create more than one fs widget
W.update_fs = lain.widget.fs({
  settings  = function()
    W.fs:set_markup(markup(gmc.color['white'], fs_now["/"].percentage .. "% "))
  end
})

-- /home fs
I.disk = wibox.widget.imagebox(beautiful.monitor_disk)

W.disk_bar = wibox.widget {
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

W.disk_margin = wibox.layout.margin(W.disk_bar, 2, 7)
W.disk_margin:set_top(6)
W.disk_margin:set_bottom(9)

-- Update bar, also in widgets popups

local disk_widget_settings = function()
    if fs_now["/"].used < 90 then
        W.disk_bar:set_color(gmc.color['red300'])
    else
        W.disk_bar:set_color(gmc.color['blue300'])
    end
    W.disk_bar:set_value(fs_now["/"].percentage)
end

W.disk_widget = lain.widget.fs {
    notification_preset = { fg = theme.fg_normal, bg = theme.bg_normal, font = "Terminus 10.5" },
    settings  = disk_widget_settings
}

W.disk_bar_widget = wibox.widget.background(W.disk_margin)
W.disk_bar_widget:set_bgimage(beautiful.bar_bg_copland)

W.disk_bg = wibox.container.background(
  W.disk_bar, gmc.color['grey500'], gears.shape.rectangle)
W.disk_bar_widget = wibox.container.margin(
  W.disk_bg, dpi(2), dpi(7), dpi(6), dpi(6))
