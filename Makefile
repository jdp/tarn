# lua 5.1 and libtcod 1.2

CC = gcc
CFLAGS = -Wall -pedantic
OBJ = tarn.o
LIB = -llua5.1 -ltcod -lSDL
OUT = tarn

$(OUT): $(OBJ)
	$(CC) $(CFLAGS) -o $@ $(OBJ) $(LIB)
	
.c.o:
	$(CC) -c $<
