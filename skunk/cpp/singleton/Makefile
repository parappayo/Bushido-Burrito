
CC=g++
INC=
LIB=
OPT=-std=c++11 -Wall -pthread

all: LazySingletonTest SingletonTest

clean:
	rm *.o

LazySingletonTest: LazySingletonTest.cpp LazySingleton.h
	$(CC) LazySingletonTest.cpp -o LazySingletonTest $(INC) $(LIB) $(OPT)

SingletonTest: SingletonTest.cpp Singleton.h
	$(CC) SingletonTest.cpp -o SingletonTest $(INC) $(LIB) $(OPT)
