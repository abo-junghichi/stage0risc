#!/bin/sh

./genbody.sh < bootloader.asm > bootloader.test
if [ 0 != $? ] ; then exit 1 ; fi
diff -s bootloader.img bootloader.test
if [ 0 != $? ] ; then exit 1 ; fi
for stem in genheader numlabel linemacro autolabel
do
	./assemble.sh < $stem.asm > $stem.test
	if [ 0 != $? ] ; then exit 1 ; fi
	diff -s $stem.img $stem.test
	if [ 0 != $? ] ; then exit 1 ; fi
done
