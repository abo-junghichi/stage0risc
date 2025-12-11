{
since middle brackets are used as comment begin/end,
read [] to middle brackets.
}
{
(dp)[cont]key...[cont]key[cont]key(mp)[new cont'delim'(wp)]word(sp)]
}

{011 $ 11011 &}brac {[}
{011 $ 11101 &}cket {]}
{11111 $}eof {EOF}

:error
100 $ exit

{0v}error_delim {1v}sp_arg {10v}link {11v}sp {100v}peek {101v}key {110v}link2
:match
10 $ drops 101#
peek > error_delim > xor -error beqz
cket sp > sb
10 < 10 <
{ 0v=sp 1v=peek 10v=link }
ret
:check_delim 111#
peek > key > xor -match beqz
0 < ret
:read_word { 1v=sp } 11#
sp_arg >
:loop
getc
{-check_delim call 1-}case
001 $ 00000 & case {' '}
000 $ 01010 & case {'\n'}
brac          case
cket          case
eof           case
sp > sb
1 $ add
-loop jmp
{-read_word call}read_word

{0v}tp_arg {1v}link {10v}tp
:loop 11#
1 $ sub
tp > lb brac xor -loop bnez
1- tp_arg < 1+
ret
:search_key 10#
tp_arg >
-loop jmp
{-search_key call}search_key

{0v}dp {1v}mp {10v}wp {11v}error_delim {100v}link
{101v}sp {110v}peek {111v}tp {1000v}rst {1001v}peek_tp
:search_fail 1000#
drop wp >
:search_end 1000#
1 $ add
link > 10 < 10 < 10 <
{ dp mp wp peek rst link }
ret
:search_next 1010#
10 $ drops 1000#
search_key
:check_end 1000#
dp > tp > xor -search_fail beqz
:cmpstr
sp >
{1000v}sp_tmp
:loop 1001#
tp > 1 $ sub 0 > 1- tp < 1+ lb
sp_tmp > 1 $ sub 0 > 1- sp_tmp < 1+ lb peek_tp > xor -search_next bnez
cket xor -loop bnez
drop
search_key
-search_end jmp
:search_macro 101#
cket wp > sb
error_delim > wp > 1 $ add read_word
mp >
-check_end jmp
{-search_macro call 1+}search_macro

{0v}interp_word {1v}dp {10v}mp {11v}wp {100v}sp {101v}peek
:defmacro_end 110#
0 <
{ interp_word dp mp wp peek }
interp_word > jmpabs
:defmacro_comment 110#
mp > 1- wp < 1+
-defmacro_end jmp
:defmacro_name 101#
drop
cket wp > sb
1 $ add
cket wp > read_word
{ interp_word dp mp wp sp peek }
wp > sp > xor -defmacro_comment beqz
sp > 1- wp < 1+
sp > 1- mp < 1+
-defmacro_end jmp
:loop 111#

{100v}peek {101v}rst {110v}img_rst
wp > sb
wp > 1 $ add 1- wp < 1+
1 $ add
:expand 110#
rst > lb
img_rst > cket xor -loop bnez
10 $ drops 101#
peek > cket xor -defmacro_name beqz
peek > eof xor -error beqz
wp > sb
:search
1 $ add
brac search_macro
-expand jmp
:defmacro 101#
drop
brac wp > sb
-search jmp

:done
0 $ exit
:output 111#
putc
1 $ add
:loop 110#
rst > lb
img_rst > cket xor -output bnez
10 $ drops
:interp_word 101#
peek > brac xor -defmacro beqz
peek > eof xor -done beqz
putc
:interp_word_main 100#
cket search_macro
-loop jmp

:main { dp }
0 > -interp_word rel 1 < 0 > 0 > -interp_word_main jmp

{:entry}
-main call
{:data}
