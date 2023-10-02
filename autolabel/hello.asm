{3b}one
{10b}char

:string
{ "Hello,World!\n" padded with '\0' }
1020b 1211b 1230b 1230b
1233b 0230b 1113b 1233b
1302b 1230b 1210b 0201b
0022b     b     b     b

:do_print
putc char b b
add dp dp one
:print
lb char b dp
bnez char -do_print
system b b b

:main
lit zero b b
lit one 1b b
rel dp -string
jal tmp -print

{:entry_point}{used by genheader.img}
jal tmp -main
