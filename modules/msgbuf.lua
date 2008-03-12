-- Tarn Roguelike Engine
-- Message buffer module
-- Copyright (c) 2008 J. Poliey <jdp34@njit.edu>

-- The base MessageBuffer class table
MessageBuffer = {
	buffer = {}
}

-- Returns a new instance of the MessageBuffer class
function MessageBuffer:new()
	handle = {}
	setmetatable(handle, self)
	self.__index = self
	return handle
end

-- Adds a message to the message queue
function MessageBuffer:add(msg)
	table.insert(self.buffer, msg)
end

-- Removes and returns a message from the queue
function MessageBuffer:get()
	return table.remove(self.buffer, 1)
end

-- Returns the size of the message queue
function MessageBuffer:size()
	return table.maxn(self.buffer)
end
