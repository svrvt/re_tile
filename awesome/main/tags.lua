-- Standard awesome library
local awful = require("awful")

local _M = {}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function _M.get()
  local tags = {}

  local tagpairs = {
    --  names  = { "term", "net", "edit", "place", 5, 6, 7, 8, 9 },
    names  = {
      -- "A", "W", "E", "S" ,"O", "M", "E", "W", "M"
      "M", "E","O", "S", "E"
      -- " 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 "
      -- '󰛓 ', ' ', '󰫢 ', ' ', ' ', --' ', ' ', -- '󰥹 ',
      -- ' ', ' ', ' ', ' ', ' ', '󱛉 ', ' ' 
    },
    layout = {
      RC.layouts[2], RC.layouts[2], RC.layouts[2],
      RC.layouts[2], RC.layouts[2],
    }
  }

  awful.screen.connect_for_each_screen(function(s)
    -- Each screen has its own tag table.
    tags[s] = awful.tag(tagpairs.names, s, tagpairs.layout)
  end)

  return tags
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return setmetatable(
  {},
  { __call = function(_, ...) return _M.get(...) end }
)
