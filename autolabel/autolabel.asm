{3b}peek
{10b}count
{11b}link
{12b}tc
{13b}sp

{20b}one
{21b}two
{22b}eof
{23b}colon
{30b}brac
{31b}atmark
{32b}cket
{33b}charminus
{100b}mask
{101b}charzero

:pop_num_core
sub sp sp one
lb tmp b sp
putc tmp b b
:pop_num
xor sp tmp dp
bnez tmp -pop_num_core
ret link

:push_num_core
and tc tmp mask
add tmp tmp charzero
sb tmp b sp
add sp sp one
shrl tc tc two
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
lit two 2b b
lit eof 3333b 3333b
lit colon 0322b b
lit brac 1323b b
lit atmark 1000b b
lit cket 1331b b
lit charminus 0231b b
lit mask 3b b
lit charzero 0300b b
lit count b b
jal tmp -core

{:set_dp}
jal dp -main
{:data}
