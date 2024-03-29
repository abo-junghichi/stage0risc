{11b}tmp2
{100b}sp
{101b}wp
{110b}mp
{111b}tp
{1000b}peek
{1001b}rst
{1010b}link
{1011b}link2
{1100b}brac
{1101b}cket
{1110b}two
{1111b}one
{10000b}eof
{10001b}error_delim
{10010b}entry_interp_word

:error
system 1b b b

{
since middle brackets are used as comment begin/end,
read [] to middle brackets.
}
{
(dp)[cont]key...[cont]key[cont]key(mp)[new cont'delim'(wp)]word(sp)]
}

:table
00100000b b { ' ' }
00001010b b { '\n' }
01111011b b { [ }
01111101b b { ] }
filled filled { EOF }
b b { end of table }

:next_peek
sb peek b sp
add sp sp one
:read_word
getc peek b b
rel tp -table
:check_delim
lw tmp b tp
beqz tmp -next_peek
add tp tp two
xor peek tmp tmp
bnez tmp -check_delim
xor peek tmp error_delim
beqz tmp -error
sb cket b sp
ret link

:search_key
sub tp tp one
lb tmp b tp
xor tmp tmp brac
bnez tmp -search_key
ret link

:search_end
add wp rst one
ret link2
:search_next
jal link -search_key
:check_end
xor dp tmp tp
beqz tmp -search_end
:cmpstr
mv rst sp
:loop
sub tp tp one
sub rst rst one
lb tmp b tp
lb tmp2 b rst
xor tmp tmp2 tmp2
bnez tmp2 -search_next
xor tmp tmp cket
bnez tmp -loop
jal link -search_key
add tp rst one
ret link2
:search_macro
sb cket b wp
add wp sp one
jal link -read_word
mv tp mp
jal tmp -check_end

:defmacro_comment
mv wp mp
jalr zero tmp entry_interp_word
:defmacro_name
mv error_delim cket
sb cket b wp
add wp wp one
mv sp wp
jal link -read_word
xor wp tmp sp
beqz tmp -defmacro_comment
mv mp sp
mv wp sp
jalr zero tmp entry_interp_word
:loop
sb tmp b wp
add rst rst one
add wp wp one
:expand
lb tmp b rst
xor tmp tmp2 cket
bnez tmp2 -loop
xor peek tmp cket
beqz tmp -defmacro_name
xor peek tmp eof
beqz tmp -error
sb peek b wp
:search
add wp wp one
jal link2 -search_macro
jal tmp -expand
:defmacro
mv error_delim brac
sb brac b wp
jal tmp -search

:done
system b b b
:output
putc tmp b b
add rst rst one
:loop
lb tmp b rst
xor tmp tmp2 cket
bnez tmp2 -output
:interp_word
xor peek tmp brac
beqz tmp -defmacro
xor peek tmp eof
beqz tmp -done
putc peek b b
:interp_word_main
jal link2 -search_macro
jal tmp -loop

:main
lit zero b b
mv mp dp
mv wp dp
lit brac 01111011b b
lit cket 01111101b b
lit two 10b b
lit one 1b b
lit eof filled filled
rel entry_interp_word -interp_word
mv error_delim cket
jal tmp -interp_word_main

{:set_dp}
jal dp -main
{:data}
