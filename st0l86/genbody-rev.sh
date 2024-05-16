#!/bin/sh

VM=../emu-fast.out

cat ../head.asm - | ./autolabel.out >tmp.lm
if ./linemacro.out <tmp.lm >tmp.nl ; then true ; else exit 1 ; fi
cat ../numlabel.img tmp.nl | $VM 2>log
if [ -s log ] ; then exit 1 ; fi
rm tmp.lm tmp.nl
