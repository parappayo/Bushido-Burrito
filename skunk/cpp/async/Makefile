
CC=g++
INC=
LIB=
OPT=-std=c++11 -Wall -pthread

all: GuardedBufferTest GuardedObjectTest GuardedQueueTest

clean:
	rm *.o

GuardedBufferTest: GuardedBufferTest.cpp GuardedBuffer.cpp GuardedBuffer.h
	$(CC) GuardedBufferTest.cpp GuardedBuffer.cpp -o GuardedBufferTest $(INC) $(LIB) $(OPT)

GuardedObjectTest: GuardedObjectTest.cpp GuardedObject.h
	$(CC) GuardedObjectTest.cpp -o GuardedObjectTest $(INC) $(LIB) $(OPT)

GuardedQueueTest: GuardedQueueTest.cpp GuardedQueue.h
	$(CC) GuardedQueueTest.cpp -o GuardedQueueTest $(INC) $(LIB) $(OPT)
