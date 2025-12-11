#!/bin/sh

( cd ../ ; make emu-fast.out )
VM=../emu-fast.out
CC="gcc -O3 -Wall -pedantic -Wextra -Wstrict-aliasing=1"
$CC genheader.c -o genheader.out
$CC numlabel-rsh.c -o numlabel-rsh.out
cat ../autolabel.img head-rsh.asm autolabel-rshboot.asm | $VM 2>log >tmp.lm
if [ -s log ] ; then exit 1 ; fi
cat ../linemacro.img tmp.lm | $VM >tmp.nl 2>log
if [ -s log ] ; then exit 1 ; fi
if ./numlabel-rsh.out <tmp.nl >tmp.img ; then true ; else exit 1 ; fi
./genheader.out <tmp.img >bh.img
cat bh.img tmp.img >autolabel-rsh.img
$CC emu.c -o emu.out
for stem in bootloader genheader numlabel linemacro
do
	./assemble-rshboot.sh < $stem-rsh.asm > $stem-rsh.img
done
rm genheader.out numlabel-rsh.out
