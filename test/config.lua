-- Tarn configuration file
-- Copyright 2008 The Poppenkast

-- Basic game information
GAME_NAME = "Tarn"
GAME_VERSION = "0.1.0"

-- Font information (todo)
--FONT_FILE = "terminal.bmp"
--FONT_WIDTH, FONT_HEIGHT = 8, 12
--FONT_ROWS, FONT_COLUMNS = 16, 16

-- Physical console information
tarn_display_title = GAME_NAME .. " " .. GAME_VERSION

-- Map viewport information
VIEWPORT_X, VIEWPORT_Y = 1, 3

-- Message information
MESSAGE_X, MESSAGE_Y = 1, 1

-- Status information
STATUS_X, STATUS_Y = 1, 23

tarn_init()
