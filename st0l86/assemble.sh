#!/bin/sh

cat head.asm - | ./autolabel.out >tmp.lm
if ./linemacro.out <tmp.lm >tmp.nl ; then true ; else exit 1 ; fi
if ./numlabel.out <tmp.nl >tmp.img ; then true ; else exit 1 ; fi
./genheader.out <tmp.img >bh.img
cat bh.img tmp.img

rm tmp.lm tmp.nl tmp.img bh.img
