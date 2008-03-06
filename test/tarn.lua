-- Tarn main file
-- Tarn version 0.1.0
-- Copyright 2008 Poppenkast

-- Include basic Tarn systems
tarn_dofile("config.lua")
tarn_dofile("console.lua")
tarn_dofile("message.lua")
tarn_dofile("map.lua")
tarn_dofile("player.lua")
tarn_dofile("helper.lua")

-- Set up the initial game state
msgbuf.add(string.format("Welcome to $%d%s$0, adventurer!", color.lightgreen, "Billyrogue"))
redraw()

-- The main game loop
while true do
	-- quick message buffer test
	msgbuf.flush()
	-- get a keypress
	local raw_key = tarn_getkey()
	local key = (raw_key.vk == 65) and string.format("%c", raw_key.c) or raw_key.vk
	-- perform action depending on keypress
	if key == "Q" then
		redraw()
		if choice("Are you sure", "yn") == "y" then
			break
		end
	elseif key == 14 then
		player.move(player.x, player.y - 1)
	elseif key == 17 then
		player.move(player.x, player.y + 1)
	elseif key == 15 then
		player.move(player.x - 1, player.y)
	elseif key == 16 then
		player.move(player.x + 1, player.y)
	end
	-- redraw entire screen
	redraw()
end
