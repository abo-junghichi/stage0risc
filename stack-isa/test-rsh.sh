#!/bin/sh

for stem in bootloader genheader numlabel linemacro autolabel
do
	./assemble-rsh.sh < $stem-rsh.asm > $stem.test
	if [ 0 != $? ] ; then exit 1 ; fi
	diff -s $stem-rsh.img $stem.test
	if [ 0 != $? ] ; then exit 1 ; fi
done
