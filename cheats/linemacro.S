#include "nlheader.S"

#define tmp2 03
#define sp 04
#define wp 05
#define mp 06
#define tp 07
#define peek 08
#define rst 09
#define link 0a
#define link2 0b
#define brac 0c
#define cket 0d
#define two 0e
#define one 0f
#define eof 10
#define error_delim 11
#define entry_interp_word 12

:error
system 01 00 00

/*
(dp){cont}...{cont}key{cont}key(mp){new cont'delim'(wp)'}'[word](sp)'}'
*/

:table
20 00 /* ' ' */
0a 00 /* '\n' */
7b 00 /* '{' */
7d 00 /* '}' */
ff ff /* EOF */
00 00 /* end of table */

:next_peek
sb peek 00 sp
add sp sp one
:read_word
getc peek 00 00
rel tp -table
:check_delim
lw tmp 00 tp
beqz tmp -next_peek
add tp tp two
xor peek tmp tmp
bnez tmp -check_delim
xor peek tmp error_delim
beqz tmp -error
sb cket 00 sp
ret link

:search_key
sub tp tp one
lb tmp 00 tp
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
lb tmp 00 tp
lb tmp2 00 rst
xor tmp tmp2 tmp2
bnez tmp2 -search_next
xor tmp tmp cket
bnez tmp -loop
jal link -search_key
add tp rst one
ret link2
:search_macro
sb cket 00 wp
add wp sp one
jal link -read_word
mv tp mp
jal tmp -check_end

:defmacro_comment
mv wp mp
jalr zero tmp entry_interp_word
:defmacro_name
mv error_delim cket
sb cket 00 wp
add wp wp one
mv sp wp
jal link -read_word
xor wp tmp sp
beqz tmp -defmacro_comment
mv mp sp
mv wp sp
jalr zero tmp entry_interp_word
:loop
sb tmp 00 wp
add rst rst one
add wp wp one
:expand
lb tmp 00 rst
xor tmp tmp2 cket
bnez tmp2 -loop
xor peek tmp cket
beqz tmp -defmacro_name
xor peek tmp eof
beqz tmp -error
sb peek 00 wp
:search
add wp wp one
jal link2 -search_macro
jal tmp -expand
:defmacro
mv error_delim brac
sb brac 00 wp
jal tmp -search

:done
system 00 00 00
:output
putc tmp 00 00
add rst rst one
:loop
lb tmp 00 rst
xor tmp tmp2 cket
bnez tmp2 -output
:interp_word
xor peek tmp brac
beqz tmp -defmacro
xor peek tmp eof
beqz tmp -done
putc peek 00 00
:interp_word_main
jal link2 -search_macro
jal tmp -loop

:main
lit zero 00 00
mv mp dp
mv wp dp
lit brac 7b 00
lit cket 7d 00
lit two 02 00
lit one 01 00
lit eof ff ff
rel entry_interp_word -interp_word
mv error_delim cket
jal tmp -interp_word_main

:set_dp
jal dp -main
:data
