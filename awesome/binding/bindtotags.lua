-- Standard awesome library
local gears = require("gears")
local awful = require("awful")

local _M = {}
local modkey = RC.vars.modkey

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- {{{ Key bindings

-- Привязать все номера клавиш к тегам.
-- Будьте внимательны: мы используем коды клавиш, чтобы заставить его работать на любой раскладке клавиатуры.
-- Это должно отображаться на верхнем ряду вашей клавиатуры, обычно от 1 до 9.
function _M.get(globalkeys)
  for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,

      --  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
      -- Переключиться на тег.
      awful.key({ modkey }, "#" .. i + 9,
        function()
          local screen = awful.screen.focused()
          local tag = screen.tags[i]
          if tag then
            tag:view_only()
          end
        end,
        { description = "перейти на тег #" .. i, group = "tag" }),

      --  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
      -- Временно отобразить клиент в другом теге
      awful.key({ modkey, "Control" }, "#" .. i + 9,
        function()
          local screen = awful.screen.focused()
          local tag = screen.tags[i]
          if tag then
            awful.tag.viewtoggle(tag)
          end
        end,
        {
          description = "просматривать клиент в теге #" .. i,
          group = "tag"
        }),

      --  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
      -- Перенести клиент.
      awful.key({ modkey, "Shift" }, "#" .. i + 9,
        function()
          if client.focus then
            local tag = client.focus.screen.tags[i]
            if tag then
              client.focus:move_to_tag(tag)
            end
          end
        end,
        { description = "перенести клиент в тег #" .. i, group = "tag" }),

      --  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
      -- Дублировать фокус клиента на тег
      awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
        function()
          if client.focus then
            local tag = client.focus.screen.tags[i]
            if tag then
              client.focus:toggle_tag(tag)
            end
          end
        end,
        {
          description = "дублировать фокус клиента на тег #" .. i,
          group = "tag"
        })

    --  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
    )
  end

  return globalkeys
end

-- }}}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return setmetatable({}, {
  __call = function(_, ...) return _M.get(...) end
})
