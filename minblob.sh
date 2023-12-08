#!/bin/sh

VM=./emu-fast.out

for stem in autolabel linemacro
do
	cat autolabel.img $stem.asm | $VM 2>log >$stem.lm
	if [ -s log ] ; then exit 1 ; fi
done
rm autolabel.img
cat linemacro.img head.asm linemacro.lm | $VM 2>log >linemacro.nl
if [ -s log ] ; then exit 1 ; fi
rm linemacro.img linemacro.lm log
