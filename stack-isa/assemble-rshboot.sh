#!/bin/sh

VM=../emu-fast.out

cat autolabel-rsh.img head-rsh.asm - | ./emu.out >tmp.lm 2>log
if [ -s log ] ; then exit 1 ; fi
cat ../linemacro.img tmp.lm | $VM >tmp.nl 2>log
if [ -s log ] ; then exit 1 ; fi
if ./numlabel-rsh.out <tmp.nl >tmp.img ; then true ; else exit 1 ; fi
./genheader.out <tmp.img >bh.img
cat bh.img tmp.img
rm tmp.lm tmp.nl tmp.img bh.img log
