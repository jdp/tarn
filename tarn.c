/* Copyright (c) 2008 The Poppenkast */

#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <lua5.1/lua.h>
#include <lua5.1/lualib.h>
#include <lua5.1/lauxlib.h>
#include <libtcod/libtcod.h>
#include "tarn.h"

/* Handle to the Lua interpreter */
lua_State *L;

/* Initializes Tarn - Lua, libtcod, etc */
void init(void) {
	/* Initialize the Lua interpreter */
	L = luaL_newstate();
	luaL_openlibs(L);
	/* Register custom functions available to Lua */
	lua_register(L, "tarn_init", tarnapi_init);
	lua_register(L, "tarn_dofile", tarnapi_dofile);
	lua_register(L, "tarn_print", tarnapi_printat);
	lua_register(L, "tarn_getkey", tarnapi_getkey);
	lua_register(L, "tarn_clear", tarnapi_clear);
	lua_register(L, "tarn_draw", tarnapi_draw);
}

/* Start the game! */
void start() {
	if (luaL_dofile(L, START_SCRIPT) == 1) {
		fprintf(stderr, "Error in %s:\n", START_SCRIPT);
		fprintf(stderr, "\t%s\n", lua_tostring(L, -1));
		lua_pop(L, 1);
	}
}

/* Clean up the Tarn engine */
void end() {
	lua_close(L);
}

/* Returns a value from Lua global variables from Tarn */
const char* tarn_global(char *option) {
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
	/* Make sure enough arguments were passed */
	if (lua_gettop(LS) < 1)
		return 0;
	/* Fetch the arguments passed */
	const char *filename = lua_tostring(LS, 1);
	lua_pop(LS, 1);
	/* Run file and catch errors */
	if (luaL_dofile(L, filename) == 1) {
		fprintf(stderr, "Error in %s:\n", filename);
		fprintf(stderr, "\t%s\n", lua_tostring(L, -1));
		lua_pop(L, 1);
	}
	return 1;
}

/* Tarn API call to initialize the game */
static int tarnapi_init(lua_State *LS) {
	const char *cont = "Tarn";
	int conw = 80, conh = 25;
	
	/* Use a custom console title, if provided */
	if (tarn_global("tarn_console_title") != NULL)
		cont = tarn_global("tarn_console_title");
		
	/* Use custom console dimensions */
	if (tarn_global("tarn_console_width") != NULL)
		conw = atoi(tarn_global("tarn_console_width"));
	if (tarn_global("tarn_console_height") != NULL)
		conh = atoi(tarn_global("tarn_console_height"));
	
	/* Open the libtcod console */
	TCOD_color_t key = {0, 0, 0};
	TCOD_console_set_custom_font("font8x12.bmp", 8, 12, 16, 16, 0, key);
	TCOD_console_init_root(conw, conh, cont, false);
	TCOD_console_set_foreground_color(NULL, color_table[15]);
	
	/* Set the tarn_initialized flag */
	lua_pushinteger(LS, 1);
	lua_setglobal(LS, "tarn_initialized");
	
	return 1;
}

/* Tarn API call for Lua to print things on-screen */
static int tarnapi_printat(lua_State *LS) {
	/* Make sure Tarn console is open */
	if (tarn_global("tarn_initialized") == NULL) {
		lua_pushstring(LS, "can't call tarn_print before tarn_init");
		lua_error(LS);
		return 0;
	}
	/* Make sure enough arguments were passed */
	int stacksize = lua_gettop(LS);
	if (stacksize < 3)
		return 0;
	/* Fetch all the arguments passed */
	int x = lua_tonumber(LS, -3);
	int y = lua_tonumber(LS, -2);
	const char *s = lua_tostring(LS, -1);
	lua_pop(LS, 3);
	/* Print s at x,y with control codes */
	TCOD_bkgnd_flag_t bkgnd = TCOD_BKGND_NONE;
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
	return 1;
}

/* Tarn API call for Lua to read a keypress */
static int tarnapi_getkey(lua_State *LS) {
	/* Make sure Tarn console is open */
	if (tarn_global("tarn_initialized") == NULL) {
		lua_pushstring(LS, "can't call tarn_getkey before tarn_init");
		lua_error(LS);
		return 0;
	}
	/* Read the keystroke from libtcod */
	TCOD_key_t key;
	key = TCOD_console_wait_for_keypress(true);
	/* Create a table with the libtcod key_t structure */
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
	/* Make sure Tarn console is open */
	if (tarn_global("tarn_initialized") == NULL) {
		lua_pushstring(LS, "can't call tarn_clear before tarn_init");
		lua_error(LS);
		return 0;
	}
	/* Clear the libtcod console */
	TCOD_console_clear(NULL);
	return 1;
}

/* Tarn API call for Lua to refresh the screen */
static int tarnapi_draw(lua_State *LS) {
	/* Make sure Tarn console is open */
	if (tarn_global("tarn_initialized") == NULL) {
		lua_pushstring(LS, "can't call tarn_draw before tarn_init");
		lua_error(LS);
		return 0;
	}
	/* Flush the libtcod console */
	TCOD_console_flush();
	return 1;
}

/* Initialize, start, play, end, and finish */
int main(int argc, char *argv[]) {
	init();
	start();
	end();
	return 0;
}
