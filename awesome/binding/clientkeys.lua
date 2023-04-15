-- Standard Awesome library
local gears = require("gears")
local awful = require("awful")

local _M = {}
local modkey = RC.vars.modkey

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- Клавиши управления окном
function _M.get()
  local clientkeys = gears.table.join(
  --   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
    awful.key({ modkey }, "n", function(c) c.minimized = true end,
      { description = "свернуть", group = "client" }),
    awful.key({ modkey }, "c", function(c) c:kill() end,
      { description = "закрыть", group = "client" }),
    awful.key({ modkey }, "x", awful.client.floating.toggle,
      { description = "сделать плавающим", group = "client" }),

-- brockcochranfunc
-- монитор?
	-- awful.key({ modkey, "Control" }, "h", function (c) move_client_to_screen(c, c.screen.index-1) end,
	-- 	{description = "move client one screen left", group = "client"}),
	-- awful.key({ modkey, "Control" }, "l", function (c) move_client_to_screen(c, c.screen.index+1) end,
	-- 	{description = "move client one screen right", group = "client"}),

    -- awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
    --           {description = "move to master", group = "client"}),
    -- awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
    --           {description = "move to screen", group = "client"}),
    awful.key({ modkey }, "t", function(c) c.ontop = not c.ontop end,
      { description = "закрепить поверх других", group = "client" }),
    awful.key({ modkey }, "f", function(c)
      c.fullscreen = not c.fullscreen
      c:raise()
    end,
      { description = "на весь экран", group = "client" }),
    awful.key({ modkey }, "m", function(c)
      c.maximized = not c.maximized
      c:raise()
    end,
      { description = "(ре)максимизировать", group = "client" }),
    awful.key({ modkey, "Shift" }, "m",
      function(c)
        c.maximized_vertical = not c.maximized_vertical
        c:raise()
      end,
      { description = "(ре)максимизировать по вертикали", group = "client" }),
    awful.key({ modkey, "Control" }, "m",
      function(c)
        c.maximized_horizontal = not c.maximized_horizontal
        c:raise()
      end,
      {
        description = "(ре)максимизировать по горизонтали",
        group = "client"
      }),

    --   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
    -- Custom Fix Size
    awful.key({ modkey, "Mod1" }, "Up",
      function(c)
        c.floating = not c.floating
        c.width    = 480
        c.x        = (c.screen.geometry.width - c.width) * 0.5
        c.height   = 400
        c.y        = (c.screen.geometry.height - c.height) * 0.5
      end,
      { description = "480px * 400px", group = "client" }),
    awful.key({ modkey, "Mod1" }, "Down",
      function(c)
        c.floating = not c.floating
        c.width    = 480
        c.x        = (c.screen.geometry.width - c.width) * 0.5
        c.height   = 600
        c.y        = (c.screen.geometry.height - c.height) * 0.5
      end,
      { description = "480px * 600px", group = "client" }),
    awful.key({ modkey, "Mod1" }, "Left",
      function(c)
        c.floating = not c.floating
        c.width    = 600
        c.x        = (c.screen.geometry.width - c.width) * 0.5
        c.height   = c.screen.geometry.height * 0.5
        c.y        = c.screen.geometry.height * 0.25
      end,
      { description = "600px * 50%", group = "client" }),
    awful.key({ modkey, "Mod1" }, "Right",
      function(c)
        c.floating = not c.floating
        c.width    = 320
        c.x        = (c.screen.geometry.width - c.width) * 0.5
        c.height   = 400
        c.y        = (c.screen.geometry.height - c.height) * 0.5
      end,
      { description = "800px * 50%", group = "client" }),

    awful.key({ modkey, "Control" }, "t",
      function(c)
        awful.titlebar.toggle(c, "top")
      end,
      { description = "toggle titlebar", group = "client" })

  )

  return clientkeys
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return setmetatable({}, {
  __call = function(_, ...) return _M.get(...) end
})
