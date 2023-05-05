-- {{{ Required libraries
-- Standard awesome library
local awful     = require("awful")
local beautiful = require("beautiful")

-- Wibox handling library
local wibox     = require("wibox")

-- Custom Local Library
local vw        = require("statusbar.vicious.vicious")
-- }}}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local WB        = wibox_package

function WB.initdeco()
    -- Spacer
    WB.spacer     = wibox.widget.textbox(" ")
    WB.spacerline = wibox.widget.textbox(" | ")

    -- Separators png
    WB.ar_lr_pre  = wibox.widget.imagebox()
    WB.ar_lr_pre:set_image(beautiful.arrow_lr_pre)
    WB.ar_lr_post = wibox.widget.imagebox()
    WB.ar_lr_post:set_image(beautiful.arrow_lr_post)
    WB.ar_lr_thick = wibox.widget.imagebox()
    WB.ar_lr_thick:set_image(beautiful.arrow_lr_thick)
    WB.ar_lr_thin = wibox.widget.imagebox()
    WB.ar_lr_thin:set_image(beautiful.arrow_lr_thin)

    WB.ar_rl_pre = wibox.widget.imagebox()
    WB.ar_rl_pre:set_image(beautiful.arrow_rl_pre)
    WB.ar_rl_post = wibox.widget.imagebox()
    WB.ar_rl_post:set_image(beautiful.arrow_rl_post)
    WB.ar_rl_thick = wibox.widget.imagebox()
    WB.ar_rl_thick:set_image(beautiful.arrow_rl_thick)
    WB.ar_rl_thin = wibox.widget.imagebox()
    WB.ar_rl_thin:set_image(beautiful.arrow_rl_thin)
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function WB.add_widgets_monitor_left(line, s)
    local ic = icon_set

    return {
        layout = wibox.layout.fixed.horizontal,
        WB.ar_lr_post,
        WB.spacer,
        vw.hddtemp,
        WB.spacer,
        vw.graph_cpu,
        WB.spacer,
        ic.cpu,
        vw.cpu,
        WB.spacerline,
        vw.graph_mem,
        WB.spacer,
        ic.mem,
        vw.mem,
        WB.spacer,
        WB.ar_lr_thin,
        WB.spacer,
        vw.battery,
        WB.spacerline,
        vw.net
    }
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function WB.add_widgets_monitor_right(line, s)
    local ic = icon_set
    local tl = text_label

    return {
        layout = wibox.layout.fixed.horizontal,
        WB.spacer,
        ic.cpu,
        tl.cpu,
        vw.progress_cpu,
        WB.spacer,
        ic.mem,
        tl.mem,
        vw.progress_mem,
        WB.spacer,
        WB.ar_rl_thin,
        vw.mpd,
        WB.spacerline,
        vw.date,
        WB.ar_rl_pre,
    }
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function WB.generate_wibox_two(s)
    -- layout: l_left, l_mid, tasklist

    -- Create the wibox
    s.wibox_two = awful.wibar({ position = "bottom", screen = s, height = 20 })

    -- Add widgets to the wibox
    s.wibox_two:setup {
        layout = wibox.layout.align.horizontal,
        WB.add_widgets_monitor_left(s),
        WB.spacer,
        WB.add_widgets_monitor_right(s),
    }
end
