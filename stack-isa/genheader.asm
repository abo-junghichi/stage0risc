:loop
1 > putc
1 > 1000 $ shrl 1 <
1 $ sub
:print_header { size size count }
0 > -loop bnez

10 $ drops
10 $ sub
{000 $ 11111 + and}arg_mask
0 > 101 $ shrl arg_mask 011 $ 00000 + or putc
arg_mask 111 $ 00000 + or putc
00001 $ putc {op_rel}
00010 $ putc {op_jmp}
0 $ exit

:loop
1 $ add
:get_size { size }
getc 11111 $ xor -loop bnez
0 > 100 $ add 100 $
-print_header jmp

:main
0 $
-get_size jmp

{:entry}
-main jmp
