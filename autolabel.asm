{11b}peek
{100b}count
{101b}link
{110b}tc
{111b}sp

{1000b}one
{1001b}eof
{1010b}colon
{1011b}brac
{1100b}atmark
{1101b}cket
{1110b}charminus
{1111b}charzero

:pop_num_core
sub sp sp one
lb tmp b sp
putc tmp b b
:pop_num
xor sp tmp dp
bnez tmp -pop_num_core
ret link

:push_num_core
and tc tmp one
add tmp tmp charzero
sb tmp b sp
add sp sp one
shrl tc tc one
:push_num
bnez tc -push_num_core
jal tmp -pop_num

:print_count
mv sp dp
mv tc count
jal tmp -push_num

:exit
system b b b

:skip_comment
getc peek b b
xor peek tmp eof
beqz tmp -exit
putc peek b b
xor peek tmp cket
bnez tmp -skip_comment
:core
getc peek b b
xor peek tmp eof
beqz tmp -exit
putc peek b b
xor peek tmp brac
beqz tmp -skip_comment
xor peek tmp colon
bnez tmp -core
putc brac b b
jal link -print_count
add count count one
putc atmark b b
putc cket b b
putc charminus b b
jal tmp -core

:main
lit zero b b
lit one 1b b
lit eof filled filled
lit colon 00111010b b
lit brac 01111011b b
lit atmark 01000000b b
lit cket 01111101b b
lit charminus 00101101b b
lit charzero 00110000b b
lit count b b
jal tmp -core

{:set_dp}
jal dp -main
{:data}
