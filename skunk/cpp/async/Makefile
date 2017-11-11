
CC=g++
INC=
LIB=
OPT=-std=c++11

all: GuardedBufferTest

clean:
	rm *.o

GuardedBufferTest: GuardedBufferTest.cpp GuardedBuffer.cpp GuardedBuffer.h
	$(CC) GuardedBufferTest.cpp GuardedBuffer.cpp -o GuardedBufferTest $(INC) $(LIB) $(OPT)
