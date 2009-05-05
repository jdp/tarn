CC = gcc
# libtcod doesn't have a 'make install' yet for whatever reason
# point this to your libtcod directory
LIBTCOD = /home/justin/src/libtcod-1.4.0
CFLAGS = -L$(LIBTCOD) -I$(LIBTCOD)/include
SRC = tarn.c
OBJ = ${SRC:.c=.o}
LIB = -llua5.1 -ltcod
OUT = tarn

$(OUT): $(OBJ)
	$(CC) $(CFLAGS) -o $@ $(OBJ) $(LIB)

.c.o:
	$(CC) $(CFLAGS) -c $<
