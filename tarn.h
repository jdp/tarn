/* Copyright (c) 2008 The Poppenkast */

/* The name of the startup script */
#define START_SCRIPT	"tarn.lua"

/* The base color table. Eventually will be mutable */
TCOD_color_t color_table[] = {
	{0,		0,		0},		/* 1 - black		*/ 
	{255,	255,	255},	/* 2 - white		*/
	{152,	75,		67},	/* 3 - red			*/
	{121,	193,	200},	/* 4 - cyan			*/
	{155,	81,		165},	/* 5 - purple		*/
	{104,	174,	92},	/* 6 - green		*/
	{82,	66,		157},	/* 7 - blue			*/
	{201,	214,	132},	/* 8 - yellow		*/
	{155,	103,	57},	/* 9 - orange		*/
	{106,	84,		0},		/* 10 - brown		*/
	{195,	123, 	117},	/* 11 - lightred	*/
	{99,	99,		99},	/* 12 - darkgrey	*/
	{138,	138,	138},	/* 13 - grey		*/
	{163,	229,	153},	/* 14 - lightgreen	*/
	{138,	123,	206},	/* 15 - lightblue	*/
	{173,	173,	173}	/* 16 - lightgrey	*/
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
