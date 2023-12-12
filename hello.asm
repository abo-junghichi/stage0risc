{11b}one
{100b}char

:string
{ "Hello,World!\n" padded with '\0' }
01001000b 01100101b 01101100b 01101100b
01101111b 00101100b 01010111b 01101111b
01110010b 01101100b 01100100b 00100001b
00001010b         b         b         b

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
