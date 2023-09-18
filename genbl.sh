#!/bin/sh

VM=./emu-fast.out
cat linemacro.img head.asm bootloader.asm | $VM 2>log >tmp.nl
if [ -s log ] ; then exit 1 ; fi
cat numlabel.img tmp.nl | $VM 2>log >bootloader.test
if [ -s log ] ; then exit 1 ; fi
