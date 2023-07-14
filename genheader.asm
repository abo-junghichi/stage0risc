{0003b}size
{0010b}one
{0011b}eof
{0012b}len

:{@}-loop
add size size one
:{1@}-count
getc tmp b b
xor tmp tmp eof
bnez tmp -loop
lit tmp 0010b b
add size len tmp
lit eof 0020b b
:{2@}-loop
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
:{3@}-main
lit size b b
lit one 1b b
lit eof 3333b 3333b
jal tmp -count

{:set_dp}
jal dp -main
{:data}
