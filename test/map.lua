-- Tarn map system
-- Copyright 2008 The Poppenkast

-- The tile table
tile = {
	player	= { glyph = '@', color = color.white },
	floor	= { glyph = '.', color = color.grey, walkable = true },
	wall	= { glyph = '#', color = color.darkgrey, walkable = false },
	path	= { glyph = '.', color = color.grey, walkable = true },
	doorc	= { glyph = '+', color = color.brown, walkable = false },
	dooro	= { glyph = '/', color = color.brown, walkable = true },
	empty	= { glyph = ' ', color = color.black, walkable = false }
}

-- Initialize map variables
map, fov_mask = {}, {}

-- Set the size of the map
map.WIDTH, map.HEIGHT = 200, 200

-- Initializes the map (carves sections, fills with empties)
function map.init()
	local x, y
	for x = 0, (map.WIDTH - 1) do
		map[x], fov_mask[x] = {}, {}
		for y = 0, (map.HEIGHT - 1) do
			map[x][y], fov_mask[x][y] = tile.wall, 1
		end
	end
end

-- Dig a room out of the map
function map.digRoom(x, y, w, h)
	local dx, dy
	for dy = y, (y + h) do
		for dx = x, (x + w) do
			map[dx][dy] = tile.floor
		end
	end
end

-- Make a path between two points on the map
function map.digPath(x1, y1, x2, y2)
	local delta_x = (x1 > x2) and -1 or 1
	local delta_y = (y1 > y2) and -1 or 1
	local cx = x1
	while cx ~= x2 do
		map[cx][y1] = tile.path
		cx = cx + delta_x
	end
	local cy = y1
	while cy ~= y2 do
		map[x2][cy] = tile.path
		cy = cy + delta_y
	end
	map[x1][y1] = tile.dooro
	map[x2][y2] = tile.dooro
end

-- Dig a whole dungeon level
function map.dig()
	math.randomseed(os.time())
	local room, rooms, room_x, room_y, room_width, room_height
	local last_room_x, last_room_y
	rooms = math.random(25, 50)
	for room = 0, rooms do
		if (room > 0) then
			last_room_x = room_x
			last_room_y = room_y
			last_room_width = room_width
			last_room_height = room_height
		end
		room_width = math.random(9, 15)
		room_height = math.random(7, 13)
		room_x = 1 + math.random(0, map.WIDTH - room_width - 3)
		room_y = 1 + math.random(0, map.HEIGHT - room_height - 3)
		map.digRoom(room_x, room_y, room_width, room_height)
		if (room > 0) then
			local door_x, door_y = room_x, room_y
			map.digPath(door_x, door_y, last_room_x, last_room_y)
		end
	end
end

--function map.dig()
--	math.randomseed(os.time())
	-- create a stack of possible rooms
--end function

-- Draw the map on the console
function map.draw(p, fx, fy)
	local radius_x, radius_y = 14, 9
	local top_x, top_y = fx - radius_x, fy - radius_y
	if top_x < 0 then top_x = 0 end
	if top_y < 0 then top_y = 0 end
	if (top_x + radius_x * 2) >= map.WIDTH then
		top_x = map.WIDTH - radius_x * 2
	end
	if (top_y + radius_y * 2) >= map.HEIGHT then
		top_y = map.HEIGHT - radius_y * 2
	end
	for y = top_y, (top_y + (radius_y * 2)) do
		for x = top_x, (top_x + (radius_x * 2)) do
			if (x >= 0) and (y >= 0) and (x < map.WIDTH) and (y < map.HEIGHT) then
				if (x == p.x) and (y == p.y) then
					tarn_print(VIEWPORT_X + x - top_x, VIEWPORT_Y + y - top_y, tile.player.glyph)
				else
					tarn_print(VIEWPORT_X + x - top_x, VIEWPORT_Y + y - top_y, map[x][y].glyph)
				end
			end
		end
	end
end

-- Returns a free tile on the map
function map.free()
	local try_x, try_y
	local found = false
	while not found do
		try_x = math.random(0, map.WIDTH)
		try_y = math.random(0, map.HEIGHT)
		found = map.walkable(try_x, try_y)
	end
	return try_x, try_y
end

-- Checks whether or not a tile is walkable
function map.walkable(x, y)
	if (x < 0) or (y < 0) then
		return false
	elseif (x > (map.WIDTH - 1)) or (y > (map.HEIGHT - 1)) then
		return false
	else
		return map[x][y].walkable
	end
end

-- Set up the map for Tarn
map.init()
map.dig()
