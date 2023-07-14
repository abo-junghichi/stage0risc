{3b}link
{ret link}ret

{10b}sp
{11b}imm
{12b}pos
{13b}peek
{20b}tp
{21b}four
{22b}two

:{@}-error
system 1b b b

:{1@}-end_of_file
bnez imm -error
system b b b

:{2@}-shiftin
shl imm imm two
lit tmp 300b b { '0' }
sub peek tmp tmp
or imm imm tmp
ret

:{3@}-write_byte
lit tmp 1b b
add pos pos tmp
:{10@}-write_byte_core
putc imm b b
lit imm b b
ret

:{11@}-def_label
sd pos b sp
add sp sp four
ret

:{12@}-ref_label
shl imm imm two
add imm imm dp
ld imm b imm
sub imm imm pos
add imm imm two
add pos pos two
putc imm b b
lit tmp 20b b
shra imm imm tmp
jal tmp -write_byte_core

:{13@}-whitespace
ret

:{20@}-table
0200b b -whitespace { ' ' }
0022b b -whitespace { '\n' }
0300b b -shiftin { '0' }
0301b b -shiftin
0302b b -shiftin
0303b b -shiftin
1202b b -write_byte { 'b' }
0322b b -def_label { ':' }
1000b b -ref_label { '@' }
3333b 3333b -end_of_file { EOF }
b b -error { end of table }{ means '\0' is forced to use this }

:{21@}-loop
add tp tp four
:{22@}-search
lw tmp b tp
beqz tmp -error
xor tmp tmp peek
bnez tmp -loop
lw tmp 2b tp
jalr tmp link tp
:{23@}-read
getc peek b b
rel tp -table
jal tmp -search
:{30@}-main
lit zero b b
lit four 10b b
lit two 2b b
mv sp dp
lit pos b b
lit imm b b
jal tmp -read

{:set_dp}
jal dp -main
{:data}
