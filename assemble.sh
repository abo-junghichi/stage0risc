#!/bin/sh

VM=./emu-fast.out

if ./genbody.sh >tmp.img ; then true ; else exit 1 ; fi
cat genheader.img tmp.img | $VM 2>log >bh.img
if [ -s log ] ; then exit 1 ; fi
cat bh.img tmp.img
rm tmp.img bh.img log
