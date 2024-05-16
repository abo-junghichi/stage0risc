#!/bin/sh

for stem in genheader numlabel linemacro autolabel
do
	./assemble.sh < $stem.asm > $stem.test
	if [ 0 != $? ] ; then exit 1 ; fi
	diff -s $stem.out $stem.test
	if [ 0 != $? ] ; then exit 1 ; fi
done
