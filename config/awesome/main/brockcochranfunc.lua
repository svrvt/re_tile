-- https://brockcochran.com/1/rc.lua-2023-02-11.txt

-- Standard awesome library
local awful = require("awful")

require("awful.autofocus")

local gmath = require("gears.math")
-- Math library for moving client forward/back a tag

-- Если я закрою последнего клиента на данном теге, он автоматически переключится на тег, у которого есть клиент.
-- То есть, нет причин оставаться на пустом теге.
client.connect_signal("unmanage", function(c)
	local t = c.first_tag or awful.screen.focused().selected_tag
	for _, cl in ipairs(t:clients()) do
		if cl ~= c then
			return
		end
	end
	for _, t in ipairs(awful.screen.focused().tags) do
		if #t:clients() > 0 then
			t:view_only()
			return
		end
	end
end)

--[[ --функция не ясна
move_client_to_screen = function(c, s)
	-- This must be reset since the last time this was run.
	first_client_on_screen, singular_client_on_tag, two_or_greater_clients = false, false, false

	-- Get the current tag.
	local t = c.first_tag or awful.screen.focused().selected_tag

	-- Cycle through all clients on the current tag. If there are two or greater clients on the current tag then skip next part
	for _, cl in ipairs(t:clients()) do
		if cl ~= c then
			two_or_greater_clients = true
			break
		end
	end

	if two_or_greater_clients == false then
		-- Since the following is running, then this means that the current tag has just one client.
		singular_client_on_tag = true
		-- print("singular_client_on_tag")

		-- Cycle through all tags on current screen. Then cycle through all clients on each tag. If the current client is the first on the screen, then set variable.
		inner_loop_run = false
		for _, tg in ipairs(awful.screen.focused().tags) do
			for _, cli in ipairs(tg:clients()) do
				if inner_loop_run then break end
				if cli == c then
					first_client_on_screen = true
					-- print("first_client_on_screen")
				end
				inner_loop_run = true
			end
			-- On the screen from which you are moving the client, move to the lowest index tag that has at least one client on it. You must ignore the current tag which has a client on it at this point in time because it has not been moved yet.
			if tg ~= t then
				if #tg:clients() > 0 then
					tg:view_only()
					break
				end
			end
		end
	end

	-- Move client to new screen but also keep it on the same tag index on the new screen.
	local index = c.first_tag.index
	c:move_to_screen(s)
	local tag = c.screen.tags[index]
	c:move_to_tag(tag)
	tag:view_only()

	-- This brings the focus to the client with the mouse under it. Focus gets lost if it is a singular client on the tag and it is the first tag in the list of tags with a client on them.
	if first_client_on_screen and singular_client_on_tag then
		function focus_client_under_mouse()
			gears.timer({
				timeout = 0.1,
				autostart = true,
				single_shot = true,
				callback =  function()
					local n = mouse.object_under_pointer()
						if n ~= nil and n ~= client.focus then
							client.focus = n
						end
					end
			})
		end
		focus_client_under_mouse()
		-- print("It is both the first client on the screen and the only client on that tag.\n")
	end
end
--]]

-- Эти две функции предназначены для перемещения текущего клиента в следующий/предыдущий тег
-- и последующего перехода в этот тег.
--[[ --не работают
local function move_to_previous_tag()
	local c = client.focus
	if not c then return end
	local t = c.screen.selected_tag
	local tags = c.screen.tags
	local idx = t.index
	local newtag = tags[gmath.cycle(#tags, idx - 1)]
	c:move_to_tag(newtag)
	awful.tag.viewprev()
end
local function move_to_next_tag()
	local c = client.focus
	if not c then return end
	local t = c.screen.selected_tag
	local tags = c.screen.tags
	local idx = t.index
	local newtag = tags[gmath.cycle(#tags, idx + 1)]
	awful.tag.viewnext()
  c:move_to_tag(newtag)
end
--]]


--Нет причин для перехода к следующему/предыдущему тегу и необходимости проходить мимо пустых тегов на пути к следующему тегу с клиентом.
--Следующие две функции обходят пустые теги при переходе к следующему или предыдущему.
--[[
function view_next_tag_with_client()
	local initial_tag_index = awful.screen.focused().selected_tag.index
	while (true) do
		awful.tag.viewnext()
		local current_tag = awful.screen.focused().selected_tag
		local current_tag_index = current_tag.index
		if #current_tag:clients() > 0 or current_tag_index == initial_tag_index then
			return
    end
	end
end

function view_prev_tag_with_client()
	local initial_tag_index = awful.screen.focused().selected_tag.index
	while (true) do
		awful.tag.viewprev()
		local current_tag = awful.screen.focused().selected_tag
		local current_tag_index = current_tag.index
		if #current_tag:clients() > 0 or current_tag_index == initial_tag_index then
			return initial_tag_index
		end
	end
end

-- Toggle showing the desktop
local show_desktop = false
function show_my_desktop()
	if show_desktop then
		for _, c in ipairs(client.get()) do
			c:emit_signal(
				"request::activate", "key.unminimize", { raise = true }
			)
		end
		show_desktop = false
	else
		for _, c in ipairs(client.get()) do
			c.minimized = true
		end
		show_desktop = true
	end
end
--]]
