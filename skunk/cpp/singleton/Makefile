
CC=g++
INC=
LIB=
OPT=-std=c++11 -Wall -pthread

all: LazySingletonTest

clean:
	rm *.o

LazySingletonTest: LazySingletonTest.cpp LazySingleton.h
	$(CC) LazySingletonTest.cpp -o LazySingletonTest $(INC) $(LIB) $(OPT)
