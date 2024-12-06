{011 $ 11011 +}brac
{011 $ 11101 +}cket
{11111 $}eof

:ceil { count link _ }
drop
:end { count link }
1 > 1 $ and 001 $ 10000 + {'0'} add putc
0 < ret
:print_count { count link }
1 > 1 $ shrl
{ count link upper }
0 > -ceil beqz
-print_count call
-end jmp

:exit
0 $ exit

:skip_comment { count _ }
drop
getc
{ count peek }
0 > eof xor -exit beqz
0 > putc
0 > cket xor -skip_comment bnez
drop
:core { count }
getc
{ count peek }
0 > eof xor -exit beqz
0 > putc
0 > brac xor -skip_comment beqz
001 $ 11010 + {':'} xor -core bnez
brac putc
0 > -print_count call
1 $ add
010 $ 00000 + {'@'} putc
cket putc
001 $ 01101 + {'-'} putc
-core jmp

:main {}
0 $ -core jmp

{:entry}
-main jmp
