{11b}size
{100b}one
{101b}eof
{110b}len

:loop
add size size one
:count
getc tmp b b
xor tmp tmp eof
bnez tmp -loop
lit tmp 100b b
add size len tmp
lit eof 1000b b
:loop
putc len b b
sub tmp tmp one
shrl len len eof
bnez tmp -loop
lit tmp jal b
putc tmp b b
putc one b b
putc size b b
shrl size tmp eof
putc tmp b b
system b b b
:main
lit size b b
lit one 1b b
lit eof filled filled
jal tmp -count

{:set_dp}
jal dp -main
{:data}
