#!/bin/sh
gcc mklabel.c
./a.out > label.c
cp ../rom.c .
gcc -O3 -Wall -Wextra -Wstrict-aliasing=1 -S emu-align-asm.c
