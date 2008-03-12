
-- Tarn Roguelike Engine
-- Player module
-- Copyright (c) 2008 J. Poliey <jdp34@njit.edu>

-- Base Player table
Player = {
	name = "Xyzzy",
	glyph = "@",
	color = color.white,
	x = 0,
	y = 0
}

-- Returns a new instance of the Player class
function Player:new()
	handle = {}
	setmetatable(handle, self)
	self.__index = self
	return handle
end

