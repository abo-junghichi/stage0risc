:loop
getc 10 > sb
1 $ sub
1 > 1 $ add 1 <
:loop_begin { data_addr_const _ link data_addr length }
0 > -loop bnez
10 $ drops 0 <
ret
:read { data_addr_const length link }
10 > 10 >
-loop_begin jmp

:main { data_addr }
{alignment for ld}
0 > 11 $ add 11100 $ and
{ data_addr size_addr }
100 $ -read call
ld -read call
ret

{:entry_point}
-main call
{:data}
