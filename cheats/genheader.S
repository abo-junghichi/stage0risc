#include "nlheader.S"

#define size 03
#define one 04
#define eof 05
#define len 06

:loop
add size size one
:count
getc tmp 00 00
xor tmp tmp eof
bnez tmp -loop
lit tmp 04 00
add size len tmp
lit eof 08 00
:loop
putc len 00 00
sub tmp tmp one
shrl len len eof
bnez tmp -loop
lit tmp jal 00
putc tmp 00 00
putc one 00 00
putc size 00 00
shrl size tmp eof
putc tmp 00 00
system 00 00 00
:main
lit size 00 00
lit one 01 00
lit eof ff ff
jal tmp -count

:set_dp
jal dp -main
:data
