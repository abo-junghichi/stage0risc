#!/bin/sh

cat autolabel-rsh.img head-rsh.asm - | ./emu.out >tmp.lm 2>log
if [ -s log ] ; then exit 1 ; fi
cat linemacro-rsh.img tmp.lm | ./emu.out >tmp.nl 2>log
if [ -s log ] ; then exit 1 ; fi
cat numlabel-rsh.img tmp.nl | ./emu.out >tmp.img 2>log
if [ -s log ] ; then exit 1 ; fi
cat genheader-rsh.img tmp.img | ./emu.out >bh.img 2>log
if [ -s log ] ; then exit 1 ; fi
cat bh.img tmp.img
rm tmp.lm tmp.nl tmp.img bh.img log
