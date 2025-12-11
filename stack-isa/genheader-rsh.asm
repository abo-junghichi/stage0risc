{0v}body_size {1v}file_size {10v}count
11#
:loop
file_size > putc
file_size > 1000 $ shrl 1- file_size < 1+
1 $ sub
:print_header
count > -loop bnez

10 $ drops
1#
10 $ sub
{0v}jump_len
{000 $ 11111 & and}arg_mask
jump_len > 101 $ shrl arg_mask 011 $ 00000 & or putc
arg_mask 111 $ 00000 & or putc
00001 $ putc {op_rel}
00010 $ putc {op_jmp}
0 $ exit

1#
:loop
1 $ add
:get_size
getc 11111 $ xor -loop bnez
body_size > 100 $ add 100 $
-print_header jmp

:main 0#
0 $
-get_size jmp

{:entry}
-main jmp
