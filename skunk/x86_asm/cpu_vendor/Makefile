
all: cpu_vendor

cpu_vendor.o: cpu_vendor.s
	as -o cpu_vendor.o cpu_vendor.s

main.o: main.c
	gcc -c main.c

cpu_vendor: cpu_vendor.o main.o
	gcc -o cpu_vendor cpu_vendor.o main.o

