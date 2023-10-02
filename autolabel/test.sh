#!/bin/sh

FILE=*asm

./assemble.sh < autolabel.asm > tmp.img
diff -s autolabel.img tmp.img
if [ 0 != $? ] ; then exit 1 ; fi
for file in $FILE
do
	if [ "autolabel.asm" = $file ] ; then continue ; fi
	cat autolabel.img $file | ../emu-fast.out 2>log >tmp.asm
	if [ -s log ] ; then exit 1 ; fi
	diff -s ../$file tmp.asm
	if [ 0 != $? ] ; then exit 1 ; fi
done
rm tmp.img log tmp.asm
