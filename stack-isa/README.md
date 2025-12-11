# stage0risc on stack-machine

## machine model

This virtual machine has one monolithic memory region
which is referred with linear addressing.
And the machine manages one stack for instruction operands.
Instructions for calling sub-routines
also use the stack to place return-addresses.
strages for the stack are supplied from the memory region.

## instruction set architecture

The length of each instruction is fixed as 8 bits(1 byte).
Each instruction has 3 fields (or 4 fields for sign-extention)
as shown below.

<pre>
TOS+xxxxx = (TOS << width(xxxxx)) | xxxxx
76543210
ettsiiii
000ccccc execute code ccccc
001AAAAA bury TOS to AAAAAth stack-cell
010AAAAA pick AAAAAth stack-cell
011siiii push literal siiii (s is sign-extneded)
100ccccc execute code (code = TOS+ccccc)
101AAAAA bury NOS to (TOS+AAAAA)th stack-cell
110AAAAA pick (TOS+AAAAA)th stack-cell
111iiiii TOS shift in
</pre>

"siiii" field provides an unsigned integer operand
which is used by "tt" field.
If "e" field is set, an integer variable is popped from the stack
and left-shifted to extend the operand from the limitation of 5 bits.

The "tt" field indicates how to use the operand provided by "e--siiii" field.

* "tt" = "00" : execute primitive-code which is spacified by the operand.
* "tt" = "01" : pop value from the stack, then write it to a cell of the stack whose depth of stack is spacified by the operand.
* "tt" = "10" : read from a cell of the stack and push it to the stack.
* "tt" = "11" : push the operand to the stack.

Despite this ISA belongs to fixed length ISA,
it can handle arbitrary number of primitive-code thanks to "e" field.

## build filters

<pre>
$ ./bootstrap.sh
</pre>

## test whether the filters rebuild themselves

<pre>
$ ./test.sh
</pre>

## clear away what are built

<pre>
$ ./clean.sh
</pre>

# tracking stack-height for named variables
There is a set of codes which implements and uses named variables
by tracking stack-height of run-time at compile-time.

<pre>
$ ./bootstrap.sh
$ ./test.sh
</pre>

## see also - [The Zylin ZPU](https://github.com/zylin/zpu)

It introduces a cpu-flag to handle immediate oprands denser.
