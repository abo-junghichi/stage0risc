{0v}data_addr_const {1v}length_init {10v}link {11v}data_addr {100v}length
:loop 101#
getc data_addr > sb
1 $ sub
data_addr > 1 $ add 1- data_addr < 1+
:loop_begin
length > -loop bnez
10 $ drops 11#
{1v}link_rtn
1- link_rtn < 1+
{data_addr_const link_rtn}
ret
:read 11#
data_addr_const > length_init >
-loop_begin jmp
{-read call 1-}read

:main {0v}data_addr 1#
{alignment for ld}
data_addr > 11 $ add 11100 $ and
{1v size_addr}
100 $ read ld
{1v size}
read
ret

{:entry_point}
-main call
{:data}
