# stage0risc
The instruction set architecture
which is targeted for compiling
by [Stage0 Bootstrap for the Free Software][stage0]
is so complicated (say CISC, complex instruction set computer)
that it complicates building and inspecting
a (virtual) machine executing the ISA.
[stage0]: https://savannah.nongnu.org/projects/stage0/

This project chooses so simple RISC as MIPS-I and RISC-V are.

## Divide blob into multi-pass

[Why Functional Programming Matters][whyfunc]
[whyfunc]: https://www.cse.chalmers.se/~rjmh/Papers/whyfp.html

> The ways in which one can divide up the original problem
depend directly on the ways
in which one can glue solutions together.

When you start bootstrapping with monolithic blob,
you should treat the endless sequence of
binary (or octal or hexadecimal) numbers
as the source-code to minimize the blob.
What is worse,
as you step further implementing a new feature to the compiler,
you should re-implement all features that exist in previous step
with the new compiler which new feature is added to.
This iteration of re-implemention causes
exponential growth of the blob size,
makes a room for bugs and malwares to sneak in.
Not linear growth, because added features ease writing longer codes.

For example, below is the number of bytes of blobs
generated at early stages of stage0.

<pre>
342     stage0_monitor
250     stage1_assembler-0 //hex->binary converter
472     stage1_assembler-1 //single character labels
1006    stage1_assembler-2 //64 char labels & more addressing modes
1504    M0 //line macro assembler
</pre>

With incremental compile techniques such as [Minimal Binary Boot][mbb],
later of the two problems is avoidable.
[mbb]: https://codeberg.org/StefanK/MinimalBinaryBoot

But this project takes another approach to solve both of the problems -
divide the blob of the compiler into some programs,
then, pass the output of a program to another program as its input.
This makes inspecting more easy.
Each divided blob is small,
intermediate output of each of them is visible,
and, all of them are compiled from source code written in a decent language.

## Passes of the first stage compiler
### linemacro
This pass reads definitions
each of which is constructed from a pair of a string and a key-word,
and converts each key-word to corresponding string.
This pass enables implementing mnemonics,
and, definitions without key-word are used as comments.

### numlabel
This pass is a binary editer with address calculation for backward labels.
To minimize blob size, forward labels are omited,
labels are referred by numbers, and, numbers for labels and byte-octets
are represented as quaternary.

### genheader
Because numlabel-pass can not generate forward jumps
while the processor begins executing code from first address,
this pass generates a forward jump which executes code at last of the program.
And, append a field which inform the bootloader of program size.
To minimize blob size, this pass genarates only a header blob.
Since this project uses/emulates punched tape/card system,
you should manually concatenate
the header and the blob generated by previous pass.

## Demo
### build the target machine from C-language
<pre>
$ make emu-fast.out
</pre>
You can build other implementations than emu-fast.out.
Inspect Makefile and emu-*.c.

### compile and run the "Hello,World!" program
<pre>
$ make hello
</pre>

### re-compile and compare each blobs
<pre>
$ make test
</pre>

### chainload the bootloader
<pre>
$ make hello
Hello,World!
$ cat bootloader.img bootloader.img bootloader.img hello.test > bbbh.test
$ ./emu-fast.out < bbbh.test
Hello,World!
</pre>
