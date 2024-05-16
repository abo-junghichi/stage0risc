# stage0x86linux

This directory contains what occur
when the method of stage0risc is applied to i386-linux user environment
instead of the virtual tabulating machine.

## build filters

<pre>
$ ./bootstrap.sh
</pre>

This script generates filters as executables for i386-linux.

<pre>
$ du -b *.out
393	autolabel.out
459	genheader.out
663	linemacro.out
434	numlabel.out
1949	total
</pre>

## test whether the filters rebuild themselves

<pre>
$ ./test.sh
</pre>

## test whether the filters cross-build images for stage0risc

As autolabel.out and linemacro.out behave
what their counterpart of stage0risc,
they should cross-build images for stage0risc
by swapping filters for numlabel and genheader.

<pre>
$ ./test-rev.sh
</pre>

## clear away what are built

<pre>
$ ./clean.sh
</pre>

## see also - bcompiler

[bcompiler](https://github.com/certik/bcompiler) is
a project which targets i386-linux user environment too.
Differ from stage0x86linux, this uses method using monolithic blob
same as stage0.
