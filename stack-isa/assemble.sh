#!/bin/sh

cat autolabel.img head.asm - | ./emu.out >tmp.lm 2>log
if [ -s log ] ; then exit 1 ; fi
cat linemacro.img tmp.lm | ./emu.out >tmp.nl 2>log
if [ -s log ] ; then exit 1 ; fi
cat numlabel.img tmp.nl | ./emu.out >tmp.img 2>log
if [ -s log ] ; then exit 1 ; fi
cat genheader.img tmp.img | ./emu.out >bh.img 2>log
if [ -s log ] ; then exit 1 ; fi
cat bh.img tmp.img
rm tmp.lm tmp.nl tmp.img bh.img log
