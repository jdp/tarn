-- Tarn helper functions
-- Copyright 2008 The Poppenkast

-- Draw entire screen from scratch
function redraw()
	tarn_clear()
	map.draw(player, player.x, player.y)
	player.drawStatus()
	tarn_draw()
end

-- Prompts player for a key and returns the choice
function choice(prompt, options)
	local picked = nil
	local msg = string.format("%s? [%s]", prompt, options)
	tarn_print(MESSAGE_X, MESSAGE_Y, msg)
	tarn_draw()
	while picked == nil do
		local raw_key = tarn_getkey()
		local key = string.format("%c", raw_key.c)
		if (string.find(options, key) ~= nil) and (raw_key.vk == 65) then
			picked = key
		end
	end
	-- these crash for some reason, with no error
	--tarn_print(MESSAGE_X + string.len(msg) + 2, MESSAGE_Y, key)
	--tarn_draw()
	return picked
end

-- A brilliant deep copy (not by me)
function deepcopy(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end  -- if
        local new_table = {}
        lookup_table[object] = new_table
        for index, value in pairs(object) do
            new_table[_copy(index)] = _copy(value)
        end  -- for
        return setmetatable(new_table, _copy(getmetatable(object)))
    end  -- function _copy
    return _copy(object)
end  -- function deepcopy
