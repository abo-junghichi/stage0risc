#!/bin/sh

VM=./emu-fast.out

./genbody.sh > tmp.img
cat genheader.img tmp.img | $VM 2>log >bh.img
if [ -s log ] ; then exit 1 ; fi
cat bh.img tmp.img
rm tmp.img bh.img log
