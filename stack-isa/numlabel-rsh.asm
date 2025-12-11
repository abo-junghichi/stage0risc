{0v}data_addr {1v}main_loop {10v}label_stack
{runtime stack height}{11v}rsh {100v}pos {101v}imm {110v}peek
{110#
 main_loop > jmpabs}back_loop

111#
:whitespace
drop back_loop

111#
:shiftin
1 $ and imm > 1 $ shl or 1- imm < 1+
back_loop

{101#
0 $ back_loop}immzero

111#
:write_byte
drop
imm > 111 $ and 101 $ shl imm > 11 $ shrl 0 $ 11111 & and or putc
drop
1 $ add
immzero

111#
:def_label
10 $ drops 101#
pos > label_stack > sd
label_stack > 100 $ add 1- label_stack < 1+
immzero

111#
:ref_label
drop
10 $ shl data_addr > add ld pos > 10 $ add 0 > 1-  pos < 1+ sub
{000 $ 11111 & and}arg_mask
0 > 101 $ shrl arg_mask 011 $ 00000 & or putc
arg_mask 111 $ 00000 & or putc
immzero

111#
:set_rsh
drop
1- rsh < 1+
immzero

111#
:inc_rsh
drop
rsh > add 1- rsh < 1+
immzero

111#
:dec_rsh
drop
rsh > imm > sub 1- rsh < 1+ drop
immzero

111#
:val_pick
drop
rsh > imm > sub 1 $ sub 1- imm < 1+
back_loop

:error
101 $ exit
:end_of_file 111#
drop -error bnez
0 $ exit

{111v}key {1000v}do_rel {1001v}link
1010#
:do
1 < add 100 $ sub jmpabs
:case 1010#
peek > key > xor -do beqz
1 < drop ret

:main_loop 110#
getc
{-case call}case
001 $ 00000 & -whitespace  case {' '}
000 $ 01010 & -whitespace  case {'\n'}
001 $ 10000 & -shiftin     case {'0'}
001 $ 10001 & -shiftin     case {'1'}
011 $ 00010 & -write_byte  case {'b'}
001 $ 11010 & -def_label   case {':'}
010 $ 00000 & -ref_label   case {'@'}
001 $ 00011 & -set_rsh     case {'#'}
001 $ 01011 & -inc_rsh     case {'+'}
001 $ 01101 & -dec_rsh     case {'-'}
011 $ 10110 & -val_pick    case {'v'}
11111 $       -end_of_file case {EOF}
100 $ exit

:main 1#
{alignment for ld}
11 $ add 11100 $ and
-main_loop rel data_addr > 0 $ 0 $ 0 $
-main_loop jmp

{:entry}
-main call
{:data}
