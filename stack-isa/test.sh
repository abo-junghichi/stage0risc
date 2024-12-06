#!/bin/sh

for stem in bootloader genheader numlabel linemacro autolabel
do
	./assemble.sh < $stem.asm > $stem.test
	if [ 0 != $? ] ; then exit 1 ; fi
	diff -s $stem.img $stem.test
	if [ 0 != $? ] ; then exit 1 ; fi
done
