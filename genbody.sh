#!/bin/sh

VM=./emu-fast.out

cat autolabel.img head.asm - | $VM 2>log >tmp.lm
if [ -s log ] ; then exit 1 ; fi
cat linemacro.img tmp.lm | $VM 2>log >tmp.nl
if [ -s log ] ; then exit 1 ; fi
cat numlabel.img tmp.nl | $VM 2>log
if [ -s log ] ; then exit 1 ; fi
rm tmp.lm tmp.nl log
