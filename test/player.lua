-- Tarn player system
-- Copyright 2008 The Poppenkast

-- Handle to the player
player = {}

-- Initialize the player
function player.init()
	-- statistics
	player.level = 1
	player.experience = 0
	player.energy = 100
	-- information
	player.x = 0
	player.y = 0
end

-- Draw the player
function player.draw()
	local tile = string.format("$%d%s$0", tile.player.color, tile.player.glyph)
	tarn_print(VIEWPORT_X + 14, VIEWPORT_Y + 7, tile)
end

-- Draw the player status
function player.drawStatus()
	local level = string.format("LV $%d%d$0", color.green, player.level)
	local experience = string.format("XP $%d%d$0", color.green, player.experience)
	local energy = string.format("EN $%d%d$0", color.green, player.energy)
	local status = level .. " " .. experience .. " " .. energy
	tarn_print(STATUS_X, STATUS_Y, status)
end

-- Attempt to move the player
function player.move(x, y)
	if map.walkable(x, y) then
		player.x, player.y = x, y
	end
end

-- Pass everything back to Tarn
player.init()
player.x, player.y = map.free()
