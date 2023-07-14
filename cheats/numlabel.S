#include "nlheader.S"

#define link 03
#define return ret link

#define sp 04
#define imm 05
#define pos 06
#define peek 07
#define tp 08
#define four 09
#define two 0a

:error
system 01 00 00

:end_of_file
bnez imm -error
system 00 00 00

:shiftin
shl imm imm two
lit tmp 30 00 /* '0' */
sub peek tmp tmp
or imm imm tmp
return

:write_byte
lit tmp 01 00
add pos pos tmp
:write_byte_core
putc imm 00 00
lit imm 00 00
return

:def_label
sd pos 00 sp
add sp sp four
return

:ref_label
shl imm imm two
add imm imm dp
ld imm 00 imm
sub imm imm pos
add imm imm two
add pos pos two
putc imm 00 00
lit tmp 08 00
shra imm imm tmp
jal tmp -write_byte_core

:whitespace
return

:table
20 00 -whitespace /* ' ' */
0a 00 -whitespace /* '\n' */
30 00 -shiftin /* '0' */
31 00 -shiftin
32 00 -shiftin
33 00 -shiftin
62 00 -write_byte /* 'b' */
3a 00 -def_label /* ':' */
40 00 -ref_label /* '@' */
ff ff -end_of_file /* EOF */
00 00 -error /* end of table */ /* means '\0' is forced to use this */

:loop
add tp tp four
:search
lw tmp 00 tp
beqz tmp -error
xor tmp tmp peek
bnez tmp -loop
lw tmp 02 tp
jalr tmp link tp
:read
getc peek 00 00
rel tp -table
jal tmp -search
:main
lit zero 00 00
lit four 04 00
lit two 02 00
mv sp dp
lit pos 00 00
lit imm 00 00
jal tmp -read

:set_dp
jal dp -main
:data
