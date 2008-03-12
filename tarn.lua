-- Tarn Roguelike Engine
-- Main Tarn script
-- Copyright (c) 2008 J. Poliey <jdp34@njit.edu>

-- Include core Tarn modules
tarn_loadmodule("config")
tarn_loadmodule("ini")
tarn_loadmodule("msgbuf")
tarn_loadmodule("player")
tarn_loadmodule("monster")
tarn_loadmodule("item")
tarn_loadmodule("map")

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
