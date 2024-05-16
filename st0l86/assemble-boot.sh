#!/bin/sh

VM=../emu-fast.out

cat ../autolabel.img head.asm - | $VM 2>log >tmp.lm
if [ -s log ] ; then exit 1 ; fi
cat ../linemacro.img tmp.lm | $VM 2>log >tmp.nl
if [ -s log ] ; then exit 1 ; fi
if ./numlabel.c.out <tmp.nl >tmp.img ; then true ; else exit 1 ; fi
./genheader.c.out <tmp.img >bh.img
cat bh.img tmp.img

rm tmp.lm tmp.nl log tmp.img bh.img
