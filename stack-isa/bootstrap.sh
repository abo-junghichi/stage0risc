#!/bin/sh

( cd ../ ; make emu-fast.out )
CC="gcc -O3 -Wall -pedantic -Wextra -Wstrict-aliasing=1"
$CC genheader.c -o genheader.c.out
$CC numlabel.c -o numlabel.c.out
for stem in bootloader genheader numlabel linemacro autolabel
do
	./assemble-boot.sh < $stem.asm > $stem.img
done
$CC emu.c -o emu.out
rm genheader.c.out numlabel.c.out
