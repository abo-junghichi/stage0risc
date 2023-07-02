/*
bootloader in the rom.
*/
#include "opcode.S"
#define pass 00
#define one 01
#define tmp 02
#define len 03
#define addr 04
lit one 01 00
lit pass 01 00
lit len 04 00
rel addr +data
jal tmp +read

:loop
getc tmp 00 00
sb tmp 00 addr
add addr addr one
sub len len one
:read
bnez len -loop

beqz pass +data
lit pass 00 00
rel addr +data
ld len 00 addr
jal tmp -read
:data
