#!/bin/sh

VM=./emu-fast.out

usevm(){
	$VM 2>log
	if [ -s log ] ; then exit 1 ; fi
	rm log
}

denl(){
	cat numlabel.img $1 | usevm >tmp.img
	cat genheader.img tmp.img | usevm >bh.img
	cat bh.img tmp.img
	rm bh.img tmp.img
}

denl linemacro.nl >linemacro.img
rm linemacro.nl
cat linemacro.img head.asm autolabel.lm | usevm >tmp.nl
rm autolabel.lm
denl tmp.nl >autolabel.img
rm tmp.nl
