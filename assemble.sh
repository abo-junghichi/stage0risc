#!/bin/dash

VM=./emu-fast.out
cat linemacro.img head.asm - | $VM 2>log >tmp.nl
if [ -s log ] ; then exit 1 ; fi
cat numlabel.img tmp.nl | $VM 2>log >tmp.img
if [ -s log ] ; then exit 1 ; fi
cat genheader.img tmp.img | $VM 2>log >bh.img
if [ -s log ] ; then exit 1 ; fi
cat bh.img tmp.img
rm tmp.nl tmp.img bh.img log
