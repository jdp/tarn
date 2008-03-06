-- Tarn message handler
-- Copyright 2008 The Poppenkast

-- Handle to the message buffer
msgbuf = {}

-- Initialize the message buffer
function msgbuf.init()
	msgbuf.msgs = {}
	msgbuf.x = MESSAGE_X
	msgbuf.y = MESSAGE_Y
end

-- Add a message to the buffer
function msgbuf.add(msg)
	table.insert(msgbuf.msgs, 1, msg)
end

-- Retrieve a message from the buffer
function msgbuf.get()
	local value = table.remove(msgbuf.msgs, 1)
	return value
end

-- Get size of message buffer
function msgbuf.size()
	return table.maxn(msgbuf.msgs)
end

-- Gets all available messages and flushes them
function msgbuf.flush()
	while msgbuf.size() > 0 do
		local msg = msgbuf.get()
		if msgbuf.size() > 0 then
			msg = msg .. " [more]"
		end
		redraw()
		tarn_print(msgbuf.x, msgbuf.y, msg)
		tarn_draw()
		if msgbuf.size() > 0 then
			repeat until tarn_getkey().c == 32
		end
	end
end

-- Start up the message buffer for Tarn
msgbuf.init()