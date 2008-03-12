
-- Tarn Roguelike Engine
-- Map module
-- Copyright (c) 2008 J. Poliey <jdp34@njit.edu>

-- The tile table
Tile = {
	player	= { glyph = '@', color = color.white },
	floor	= { glyph = '.', color = color.grey, walkable = true },
	wall	= { glyph = '#', color = color.darkgrey, walkable = false },
	doorc	= { glyph = '+', color = color.brown, walkable = false },
	dooro	= { glyph = '/', color = color.brown, walkable = true },
	empty	= { glyph = ' ', color = color.black, walkable = false }
}

-- The map class
Map = {
	tiles = {},
	width = 1,
	height = 1
}

-- Returns a new instance of the Map class
function Map:new(width, height)
	handle = {}
	setmetatable(handle, self)
	self.__index = self
	handle.width, handle.height = width, height
	local x, y
	for x = 0, (width-1) do
		handle.tiles[x] = {}
		for y = 0, (height - 1) do
			handle.tiles[x][y] = Tile.empty
		end
	end
	return handle
end

-- Draws a rectangle of the given tile
function Map:fillRect(x, y, w, h, tile)
	for dy = y, (y + h - 1) do
		for dx = x, (x + w - 1) do
			self.tiles[dx][dy] = tile
		end
	end
end

-- Checks if a region on the map is free
function Map:emptyRegion(x, y, w, h)
	for dy = y, (y + h - 1) do
		for dx = x, (x + w - 1) do
			if (dx < 0) or (dx > (self.width - 1)) then
				return false
			elseif (dy < 0) or (dy > (self.height - 1)) then
				return false
			elseif self.tiles[dx][dy] ~= Tile.empty then
				return false
			end
		end
	end
	return true
end

-- Returns whether or not a map position is walkable
function Map:walkable(x, y)
	if (x < 0) or (x > (self.width - 1)) then
		return false
	elseif (y < 0) or (y > (self.height - 1)) then
		return false
	else
		return self.tiles[x][y].walkable
	end
end

-- Returns a free tile on the map
function Map:free()
	local try_x, try_y, found = 0, 0, false
	while not found do
		try_x = math.random(0, self.width)
		try_y = math.random(0, self.height)
		found = self:walkable(try_x, try_y)
	end
	return try_x, try_y
end
