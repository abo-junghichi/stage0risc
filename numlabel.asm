{11b}link
{ret link}ret

{100b}sp
{101b}imm
{110b}pos
{111b}peek
{1000b}tp
{1001b}four
{1010b}two
{1011b}one

:error
system 1b b b

:end_of_file
bnez imm -error
system b b b

:shiftin
shl imm imm one
lit tmp 00110000b b { '0' }
sub peek tmp tmp
or imm imm tmp
ret

:write_byte
add pos pos one
:write_byte_core
putc imm b b
lit imm b b
ret

:def_label
sd pos b sp
add sp sp four
ret

:ref_label
shl imm imm two
add imm imm dp
ld imm b imm
sub imm imm pos
add imm imm two
add pos pos two
putc imm b b
lit tmp 1000b b
shra imm imm tmp
jal tmp -write_byte_core

:whitespace
ret

:table
00100000b b -whitespace { ' ' }
00001010b b -whitespace { '\n' }
00110000b b -shiftin { '0' }
00110001b b -shiftin
01100010b b -write_byte { 'b' }
00111010b b -def_label { ':' }
01000000b b -ref_label { '@' }
filled filled -end_of_file { EOF }
b b -error { end of table }{ means '\0' is forced to use this }

:loop
add tp tp four
:search
lw tmp b tp
beqz tmp -error
xor tmp tmp peek
bnez tmp -loop
lw tmp 10b tp
jalr tmp link tp
:read
getc peek b b
rel tp -table
jal tmp -search
:main
lit zero b b
lit four 100b b
lit two 10b b
lit one 1b b
mv sp dp
lit pos b b
lit imm b b
jal tmp -read

{:set_dp}
jal dp -main
{:data}
