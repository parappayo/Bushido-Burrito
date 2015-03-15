
CC=g++
INC=-I/usr/include/SDL
LIB=-lSDL -lSDL_image -lGL -lGLU
OPT=-O3

BIN=gnome_maze
SRC=game_objects.cpp game_world.cpp main.cpp utils.cpp
HDR=game_objects.h game_world.h utils.h

all: $(BIN)

clean:
	rm *.o

# one-shot build rule, will rebuild all for any change
$(BIN): $(SRC) $(HDR)
	$(CC) $(SRC) -o $(BIN) $(INC) $(LIB) $(OPT)

