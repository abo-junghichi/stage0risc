{11 > jmpabs}back_loop
:whitespace
drop back_loop

:shiftin
1 $ and 1 > 1 $ shl or 0 <
back_loop

:write_byte
drop
0 > 111 $ and 101 $ shl 1 > 11 $ shrl 0 $ 11111 + and or putc
drop
1 $ add
0 $
back_loop

:def_label
10 $ drops
0 > 10 > sd
1 > 100 $ add 1 <
0 $
back_loop

:ref_label
drop
10 $ shl 100 > add ld 1 > 10 $ add 0 > 10 < sub
{000 $ 11111 + and}arg_mask
0 > 101 $ shrl arg_mask 011 $ 00000 + or putc
arg_mask 111 $ 00000 + or putc
0 $
back_loop

:error
101 $ exit
:end_of_file
drop -error bnez
0 $ exit

:do
1 < add 100 $ sub jmpabs
:case
{ data_addr main_loop label_stack pos imm peek key do_rel link }
11 > 11 > xor -do beqz
1 < drop ret

:main_loop { data_addr main_loop label_stack pos imm }
getc
{ data_addr main_loop label_stack pos imm peek }
{-case call}case
001 $ 00000 + -whitespace  case {' '}
000 $ 01010 + -whitespace  case {'\n'}
001 $ 10000 + -shiftin     case {'0'}
001 $ 10001 + -shiftin     case {'1'}
011 $ 00010 + -write_byte  case {'b'}
001 $ 11010 + -def_label   case {':'}
010 $ 00000 + -ref_label   case {'@'}
11111 $       -end_of_file case {EOF}
100 $ exit

:main { data_addr }
{alignment for ld}
11 $ add 11100 $ and
-main_loop rel 1 > 0 $ 0 $
-main_loop jmp

{:entry}
-main call
{:data}
