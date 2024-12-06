{
since middle brackets are used as comment begin/end,
read [] to middle brackets.
}
{
(dp)[cont]key...[cont]key[cont]key(mp)[new cont'delim'(wp)]word(sp)]
}

{011 $ 11011 +}brac {[}
{011 $ 11101 +}cket {]}
{11111 $}eof {EOF}

:error
100 $ exit

:match { error_delim _ link sp peek _ _ }
10 $ drops
0 > 101 > xor -error beqz
cket 10 > sb
10 < 10 <
{ sp peek link }
ret
:check_delim { error_delim _ link sp peek key link2 }
10 > 10 > xor -match beqz
0 < ret
:read_word { error_delim sp link }
1 >
:loop { error_delim _ link sp }
getc
{-check_delim call}case
001 $ 00000 + case {' '}
000 $ 01010 + case {'\n'}
brac          case
cket          case
eof           case
1 > sb
1 $ add
-loop jmp

:loop { _ link tp }
1 $ sub
0 > lb brac xor -loop bnez
1 <
{ tp link }
ret
:search_key { tp link }
1 >
-loop jmp

:search_end { dp mp wp error_delim link sp peek tp }
drop 101 < drop
{ peek mp wp error_delim link }
10 > 1 $ add 11 <
{ peek rst _ error_delim link }
1 < drop
{ peek rst link }
ret

:search_fail { dp mp wp error_delim link sp peek tp }
drop 100 >
:search_end { dp mp wp error_delim link sp peek tp }
1 $ add
11 > 10 < 10 < 10 <
{ dp mp wp peek rst link }
ret
:search_next { dp mp wp error_delim link sp peek tp _ _ }
10 $ drops
-search_key call
:check_end { dp mp wp error_delim link sp peek tp }
111 > 1 > xor -search_fail beqz
:cmpstr
10 >
:loop { dp mp wp error_delim link sp peek tp rst }
1 > 1 $ sub 0 > 10 < lb
{ dp mp wp error_delim link sp peek tp rst peek_tp }
1 > 1 $ sub 0 > 10 < lb 1 > xor -search_next bnez
cket xor -loop bnez
{ dp mp wp error_delim link sp peek tp _ }
drop
-search_key call
-search_end jmp
:search_macro { dp mp wp error_delim link }
cket 11 > sb
1 > 11 > 1 $ add -read_word call
101 >
-check_end jmp

:defmacro_end { interp_word dp mp wp _ peek }
0 <
{ interp_word dp mp wp peek }
100 > jmpabs
:defmacro_comment { interp_word dp mp wp sp peek }
11 > 10 <
-defmacro_end jmp
:defmacro_name { interp_word dp mp wp _ }
drop
cket 1 > sb
1 $ add
cket 1 > -read_word call
{ interp_word dp mp wp sp peek }
10 > 10 > xor -defmacro_comment beqz
1 > 10 <
1 > 11 <
-defmacro_end jmp
:loop { interp_word dp mp wp peek rst img_rst }
11 > sb
10 > 1 $ add 10 <
1 $ add
:expand { interp_word dp mp wp peek rst }
0 > lb
0 > cket xor -loop bnez
10 $ drops
{ interp_word dp mp wp peek }
0 > cket xor -defmacro_name beqz
0 > eof xor -error beqz
1 > sb
:search { interp_word dp mp wp }
1 $ add
brac -search_macro call
-expand jmp
:defmacro { interp_word dp mp wp _ }
drop
brac 1 > sb
-search jmp

:done
0 $ exit
:output { interp_word dp mp wp peek rst img_rst }
putc
1 $ add
:loop { interp_word dp mp wp peek rst }
0 > lb
0 > cket xor -output bnez
10 $ drops
:interp_word { interp_word dp mp wp peek }
0 > brac xor -defmacro beqz
0 > eof xor -done beqz
putc
:interp_word_main { interp_word dp mp wp }
cket -search_macro call
-loop jmp

:main { dp }
0 > -interp_word rel 1 < 0 > 0 > -interp_word_main jmp

{:entry}
-main call
{:data}
