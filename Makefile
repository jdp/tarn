# requires lua 5.1 and libtcod 1.2
# this is my linux makefile. works fine for me, should help you out

CC = gcc
CFLAGS = -Wall -pedantic
OBJ = tarn.o
LIB = -llua5.1 -ltcod
OUT = tarn

$(OUT): $(OBJ)
	$(CC) $(CFLAGS) -o $@ $(OBJ) $(LIB)
	
.c.o:
	$(CC) -c $<
