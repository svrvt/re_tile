local gmc = require("themes.gmc")

-- local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local hostname = io.popen("uname -n"):read()

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

if hostname == "pcRU" then
	theme.font = "Roboto Mono Nerd Font 16"
	theme.taglist_font = "awesomewm-font 16"
elseif hostname == "vaio" then
	theme.font = "Roboto Mono Nerd Font 12"
	theme.taglist_font = "awesomewm-font 12"
end

-- theme.font          = "Roboto Mono Nerd Font 16"
-- theme.taglist_font  = "awesomewm-font 16"

theme.bg_normal = gmc.color["brassy800"] .. "cc"
theme.bg_focus = gmc.color["brassy200"] .. "cc"
theme.bg_urgent = gmc.color["redA700"] .. "cc"
theme.bg_minimize = gmc.color["brassy950"] .. "cc"

theme.bg_systray = gmc.color["brassy900"] .. "cc"

theme.fg_normal = gmc.color["brassy100"]
theme.fg_focus = gmc.color["brassy900"]
theme.fg_urgent = gmc.color["brassy900"]
theme.fg_minimize = gmc.color["brassy800"]

theme.useless_gap = dpi(0)
theme.border_width = dpi(3)

theme.border_normal = gmc.color["brassy800"]
theme.border_focus = gmc.color["brassy200"]
theme.border_marked = gmc.color["redA700"]

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- Example:

theme.taglist_bg_focus = gmc.color["brassy200"]
-- theme.taglist_bg_focus    = "png:" .. theme_path .. "misc/copycat-holo/taglist_bg_focus.png"
theme.taglist_fg_focus = gmc.color["brassy800"]
theme.taglist_fg_occupied = gmc.color["rdB5"]
theme.taglist_fg_urgent = gmc.color["redA700"]
theme.taglist_fg_empty = gmc.color["brassy200"]
theme.taglist_spacing = 2

-- theme.tasklist_bg_normal = gmc.color['brassy800']   .. "88"
-- --theme.tasklist_bg_normal = "png:" .. theme_path .. "misc/copycat-holo/bg_focus.png"
-- theme.tasklist_bg_focus  = gmc.color['brassy200']   .. "88"
-- --theme.tasklist_bg_focus  = "png:" .. theme_path .. "misc/copycat-holo/bg_focus_noline.png"
-- theme.tasklist_fg_focus  = gmc.color['brassy900']

-- theme.titlebar_bg_normal = gmc.color['brassy800']   .. "cc"
-- theme.titlebar_bg_focus  = gmc.color['brassy200']   .. "cc"
-- theme.titlebar_fg_focus  = gmc.color['brassy900']   .. "cc"

-- Generate taglist squares:
-- local taglist_square_size = dpi(4)
-- theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
--     taglist_square_size, gmc.color['black']
-- )
-- theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
--     taglist_square_size, gmc.color['white']
-- )

-- Display the taglist squares

-- override
-- theme.taglist_squares_sel      = theme_path .. "taglist/clone/square_sel.png"
-- theme.taglist_squares_unsel    = theme_path .. "taglist/clone/square_unsel.png"

-- alternate override
-- theme.taglist_squares_sel   = theme_path .. "taglist/copycat-blackburn/square_sel.png"
-- theme.taglist_squares_unsel = theme_path .. "taglist/copycat-blackburn/square_unsel.png"
-- theme.taglist_squares_sel   = theme_path .. "taglist/copycat-zenburn/squarefz.png"
-- theme.taglist_squares_unsel = theme_path .. "taglist/copycat-zenburn/squareza.png"

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = theme_path .. "misc/default/submenu.png"

theme.menu_height = 20 -- dpi(15)
theme.menu_width = 130 -- dpi(100)
--theme.menu_context_height = 20

theme.menu_bg_normal = gmc.color["brassy700"] .. "cc"
theme.menu_bg_focus = gmc.color["brassy300"] .. "cc"
theme.menu_fg_focus = gmc.color["brassy900"]

theme.menu_border_color = gmc.color["brassy100"] .. "cc"
theme.menu_border_width = 1

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"
