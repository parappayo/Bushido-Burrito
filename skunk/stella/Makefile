ASM=dasm
INCLUDE="/home/jason/dasm/machines/atari2600/"
SRC=$(wildcard *.asm)
OBJ=$(SRC:.asm=.bin)

%.bin: %.asm
	$(ASM) $< -f3 -o$@ -I$(INCLUDE)

all: $(OBJ)

