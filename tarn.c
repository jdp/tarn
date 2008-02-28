/* Copyright (c) 2008 The Poppenkast */

#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <lua5.1/lua.h>
#include <lua5.1/lualib.h>
#include <lua5.1/lauxlib.h>
#include <libtcod/libtcod.h>
#include "tarn.h"

// Handle to the Lua interpreter
lua_State *L;

/* Initializes the Lua interpreter and interfaces it to Tarn */
void init_lua(void) {
	// Initialize the Lua interpreter
	L = luaL_newstate();
	luaL_openlibs(L);
	// Register custom functions available to Lua
	lua_register(L, "tarn_dofile", tarnapi_dofile);
	lua_register(L, "tarn_print", tarnapi_printat);
	lua_register(L, "tarn_getkey", tarnapi_getkey);
	lua_register(L, "tarn_clear", tarnapi_clear);
	lua_register(L, "tarn_draw", tarnapi_draw);
}

/* Initializes the libtcod console */
void init_console(void) {
	// Get configuration values
	const char *cont = config("CONSOLE_TITLE");
	int conw = atoi(config("CONSOLE_WIDTH"));
	int conh = atoi(config("CONSOLE_HEIGHT"));
	// Open the tcodlib console
	TCOD_color_t key = {0, 0, 0};
	TCOD_console_set_custom_font("font8x12.bmp", 8, 12, 16, 16, 0, key);
	TCOD_console_init_root(conw, conh, cont, false);
	TCOD_console_set_foreground_color(NULL, color_table[15]);
}

/* Runs the configuration script */
void configure(void) {
	// Run the configuration script
	if (luaL_dofile(L, CONFIG_SCRIPT) == 1) {
		fprintf(stderr, "Error in %s:\n", CONFIG_SCRIPT);
		fprintf(stderr, "\t%s\n", lua_tostring(L, -1));
		lua_pop(L, 1);
	}
}

void start() {
	// Start the game!
	if (luaL_dofile(L, START_SCRIPT) == 1) {
		fprintf(stderr, "Error in %s:\n", START_SCRIPT);
		fprintf(stderr, "\t%s\n", lua_tostring(L, -1));
		lua_pop(L, 1);
	}
}

void end() {
	// Clean up the Lua interpreter
	lua_close(L);
}

/* Returns a value from the Tarn config file */
const char* config(char *option) {
	const char *value = NULL;
	lua_getglobal(L, option);
	if (!lua_isnoneornil(L, -1)) {
		value = lua_tostring(L, -1);
		lua_pop(L, 1);
	}
	return value;
}

/* Tarn API call to process a Lua file */
static int tarnapi_dofile(lua_State *LS) {
	// Make sure enough arguments were passed
	if (lua_gettop(LS) < 1)
		return;
	// Fetch the arguments passed
	const char *filename = lua_tostring(LS, 1);
	lua_pop(LS, 1);
	// Run file and catch errors
	if (luaL_dofile(L, filename) == 1) {
		fprintf(stderr, "Error in %s:\n", filename);
		fprintf(stderr, "\t%s\n", lua_tostring(L, -1));
		lua_pop(L, 1);
	}
	return 0;
}

/* Tarn API call for Lua to print things on-screen */
static int tarnapi_printat(lua_State *LS) {
	// Make sure enough arguments were passed
	int stacksize = lua_gettop(LS);
	if (stacksize < 3)
		return;
	// Fetch all the arguments passed
	int x = lua_tonumber(LS, -3);
	int y = lua_tonumber(LS, -2);
	const char *s = lua_tostring(LS, -1);
	lua_pop(LS, 3);
	// Print s at x,y with control codes
	TCOD_bkgnd_flag_t bkgnd = TCOD_BKGND_NONE;
	//TCOD_console_print_left(NULL, x, y, bkgnd, s);
	int scan, color_code, offset;
	for (scan = 0, offset = 0; scan < strlen(s); scan++) {
		if (s[scan] == '$') {
			if (isdigit(s[scan+1])) {
				color_code = s[++scan] - '0';
				if (isdigit(s[scan+1]) && (color_code == 1)) {
					color_code = (color_code * 10) + (s[++scan] - '0');
				}
			}
			if (color_code == 0) {
				TCOD_console_set_foreground_color(NULL, color_table[COLOR_DEFAULT]);
			}
			else {
				TCOD_console_set_foreground_color(NULL, color_table[color_code-1]);
			}
		}
		else {
			TCOD_console_put_char(NULL, x+offset++, y, s[scan], bkgnd);
		}
	}
	return 0;
}

/* Tarn API call for Lua to read a keypress */
static int tarnapi_getkey(lua_State *LS) {
	// Read the keystroke from libtcod
	TCOD_key_t key;
	key = TCOD_console_wait_for_keypress(true);
	// Create a table with the libtcod key_t structure
	lua_newtable(LS);
	lua_pushstring(LS, "vk");
	lua_pushnumber(LS, key.vk);
	lua_settable(LS, -3);
	lua_pushstring(LS, "c");
	lua_pushnumber(LS, key.c);
	lua_settable(LS, -3);
	lua_pushstring(LS, "lalt");
	lua_pushboolean(LS, key.lalt);
	lua_settable(LS, -3);
	lua_pushstring(LS, "ralt");
	lua_pushboolean(LS, key.ralt);
	lua_settable(LS, -3);
	lua_pushstring(LS, "lctrl");
	lua_pushboolean(LS, key.lctrl);
	lua_settable(LS, -3);
	lua_pushstring(LS, "rctrl");
	lua_pushboolean(LS, key.rctrl);
	lua_settable(LS, -3);
	lua_pushstring(LS, "shift");
	lua_pushboolean(LS, key.shift);
	lua_settable(LS, -3);
	return 1;
}

/* Tarn API call for Lua to clear the screen */
static int tarnapi_clear(lua_State *LS) {
	TCOD_console_clear(NULL);
	return 0;
}

/* Tarn API call for Lua to refresh the screen */
static int tarnapi_draw(lua_State *LS) {
	TCOD_console_flush();
	return 0;
}

/* Start, play, end, and finish */
int main(int argc, char *argv[]) {
	init_lua();
	configure();
	init_console();
	start();
	end();
	return 0;
}
