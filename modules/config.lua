-- Tarn Roguelike Engine
-- Configuration and macros module
-- Copyright (c) 2008 J. Poliey <jdp34@njit.edu>

-- Configure the virtual key table
vk = {
	none = 0,
	escape = 1,
	backspace = 2,
	tab = 3,
	enter = 4,
	up = 14,
	left = 15,
	right = 16,
	down = 17,
	char = 65
}

-- Configure the color table
color = {
	none = 0,
	black = 1,
	white = 2,
	red = 3,
	cyan = 4,
	purple = 5,
	green = 6,
	blue = 7,
	yellow = 8, 
	orange = 9,
	brown = 10,
	lightred = 11,
	darkgrey = 12,
	grey = 13,
	lightgreen = 14,
	lightblue = 15,
	lightgrey = 16
}

-- A function to read a string from Tarn
function tarn_getstr(x, y)
	local data, key = "", {}
	key = tarn_getkey()
	while key.vk ~= vk.enter do
		if key.c == nil then key.c = 0 end
		if (key.c >= 33) and (key.c <= 126) then
			char = string.format("%c", key.c)
			data = data .. char
			tarn_print(x, y, data)
			tarn_draw()
		elseif key.vk == vk.backspace then
			if string.len(data) > 0 then
				tarn_print(x, y, string.rep(" ", string.len(data)))
				data = string.sub(data, 0, -2)
				tarn_print(x, y, data)
				tarn_draw()
			end
		end
		key = tarn_getkey()
	end
	return data
end

-- Waits for and returns a keypress within a set of choices
function choice(options)
	local picked = nil
	while picked == nil do
		local raw_key = tarn_getkey()
		local key = string.format("%c", raw_key.c)
		if (string.find(options, key) ~= nil) and (raw_key.vk == 65) then
			picked = key
		end
	end
	return picked
end
