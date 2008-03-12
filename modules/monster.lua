
-- Tarn Roguelike Engine
-- Monster module
-- Copyright (c) 2008 J. Poliey <jdp34@njit.edu>

-- Base Monster table
Monster = {
	name = "Grue",
	x = 0,
	y = 0,
	garbage = false
}

-- Returns a new instance of the Monster class
function Monster:new()
	handle = {}
	setmetatable(handle, self)
	self.__index = self
	return handle
end

-- Base MonsterList table
MonsterList = {}

-- Returns a new instance of the MonsterList class
function MonsterList:new()
	handle = {}
	setmetatable(handle, self)
	self.__index = self
	return handle
end

-- Adds a new monster to the list
function MonsterList:add(monster)
	table.insert(self, monster)
end

-- Removes a monster from the list
function MonsterList:remove(monster)
	for i, v in ipairs(self) do
		if v == monster then
			table.remove(self, i)
			return true
		end
	end
	return false
end

-- Cleans up the monster list
function MonsterList:cleanup()
	for i, v in ipairs(self) do
		if type(v) == "table" then
			if v.garbage == true then
				table.remove(self, i)
			end
		end
	end
end
