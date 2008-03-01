/* Copyright (c) 2008 The Poppenkast */

/* The name of the startup script */
#define START_SCRIPT	"tarn.lua"

/* The base color table. Eventually will be mutable */
TCOD_color_t color_table[] = {
	{0, 0, 0}, {255, 255, 255}, {152, 75, 67}, {121, 193, 200},
	{155, 81, 165}, {104, 174, 92}, {82, 66, 157}, {201, 214, 132},
	{155, 103, 57}, {106, 84, 0}, {195, 123, 117}, {99, 99, 99},
	{138, 138, 138}, {163, 229, 153}, {138, 123, 206}, {173, 173, 173}
};

/* The default color */
#define COLOR_DEFAULT 15

/* Function prototypes */
void init(void);
void start(void);
void end(void);

const char* tarn_global(char*);

/* A small API for Lua to interact with Tarn */
static int tarnapi_dofile(lua_State*);
static int tarnapi_init(lua_State*);
static int tarnapi_printat(lua_State*);
static int tarnapi_getkey(lua_State*);
static int tarnapi_clear(lua_State*);
static int tarnapi_draw(lua_State*);
