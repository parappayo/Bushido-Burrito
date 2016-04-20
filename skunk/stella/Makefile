ASM=dasm
SRC=$(wildcard *.asm)
OBJ=$(SRC:.asm=.bin)

%.bin: %.asm
	$(ASM) $< -f3 -o$@

all: $(OBJ)

