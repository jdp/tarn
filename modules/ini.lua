
-- Tarn Roguelike Engine
-- INI file module
-- Copyright (c) 2008 J. Poliey <jdp34@njit.edu>

-- The base Ini class table
Ini = {}

-- Returns a new instance of the Ini class
function Ini:new(filename)
	handle = {}
	setmetatable(handle, self)
	self.__index = self
	
	-- open ini file for reading
	fp = io.open(filename)
	if fp == nil then
		return nil
	else
		io.input(fp)
	end
	
	-- aggregate sections, keys, and values
	local sections, current_section = 0, nil
	for line in io.lines() do
		if string.match(line, "^%[%w+%]$") ~= nil then
			local section_name = string.match(line, "%[(%w+)%]")
			sections = sections + 1
			handle[section_name] = {}
			current_section = section_name
		elseif string.match(line, "^%s*%w+%s*=%s*.+$") ~= nil then
			if current_section ~= nil then
				local key, value = string.match(line, "^%s*(%w+)%s*=%s*(.+)$")
				handle[current_section][key] = value
				handle[sections] = current_section
			end
		end
	end
	
	-- close the file
	fp:close()
	
	-- return the instance of the class
	return handle
end
