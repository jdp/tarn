-- Tarn Roguelike Engine
-- Main Tarn script
-- Copyright (c) 2008 J. Poliey <jdp34@njit.edu>

-- Include core Tarn modules
tarn_dofile("modules/config.lua")
tarn_dofile("modules/ini.lua")
tarn_dofile("modules/msgbuf.lua")
tarn_dofile("modules/player.lua")
tarn_dofile("modules/monster.lua")
tarn_dofile("modules/item.lua")
tarn_dofile("modules/map.lua")

-- Configure the display window
tarn_display_width = 80
tarn_display_height = 25
tarn_display_title = "Tarn"
tarn_init()

-- Draw a welcome message
tarn_print(1, 1, string.format("$6Tarn Roguelike Engine$0"))
tarn_print(1, 2, "Copyright (c) 2008 J. Poliey")
tarn_draw()

-- Wait for a keypress and end
tarn_getkey()

-- Your game's entrypoint
-- Use tarn_dofile() to start your game
