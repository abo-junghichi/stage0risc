#!/bin/sh

VM=./emu-fast.out

cat autolabel.img - | $VM 2>log >tmp.asm
if [ -s log ] ; then exit 1 ; fi
cat linemacro.img head.asm tmp.asm | $VM 2>log >tmp.nl
if [ -s log ] ; then exit 1 ; fi
cat numlabel.img tmp.nl | $VM 2>log
if [ -s log ] ; then exit 1 ; fi
rm tmp.asm tmp.nl log
