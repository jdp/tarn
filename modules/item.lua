
-- Tarn Roguelike Engine
-- Item/Inventory module
-- Copyright (c) 2008 J. Poliey <jdp34@njit.edu>

-- Base Item class table
Item = {
	name = "Plugh",
	stackable = true,
	quantity = 1
}

-- Returns a new instance of the Item class
function Item:new()
	handle = {}
	setmetatable(handle, self)
	self.__index = self
	return handle
end

-- Loads item data from an INI file
function Item:load(file, section)
	local ini = Ini:new(file)
	for k, v in pairs(ini[section]) do
		self[k] = v
	end
end

-- Base ItemList class table
ItemList = {}

-- Returns a new instance of the ItemList class
function ItemList:new()
	handle = {}
	setmetatable(handle, self)
	self.__index = self
	return handle
end

-- Adds an item to the list
function ItemList:add(item)
	table.insert(self, item)
end

