
CC=g++
INC=
LIB=
OPT=-std=c++11 -Wall -pthread

all: GuardedBufferTest GuardedObjectTest

clean:
	rm *.o

GuardedBufferTest: GuardedBufferTest.cpp GuardedBuffer.cpp GuardedBuffer.h
	$(CC) GuardedBufferTest.cpp GuardedBuffer.cpp -o GuardedBufferTest $(INC) $(LIB) $(OPT)

GuardedObjectTest: GuardedObjectTest.cpp GuardedObject.h
	$(CC) GuardedObjectTest.cpp -o GuardedObjectTest $(INC) $(LIB) $(OPT)
