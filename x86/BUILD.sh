#!/bin/sh
gcc mklabel.c
./a.out > label.c
cp ../rom.c .
gcc -O3 -S emu-align-asm.c
