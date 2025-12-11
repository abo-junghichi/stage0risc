{011 $ 11011 &}brac
{011 $ 11101 &}cket
{11111 $}eof

{0v}count {1v}link {10v}upper
:ceil 11#
drop
:end 10#
count > 1 $ and 001 $ 10000 & {'0'} add putc
0 < ret
:print_count 10# { count link }
{-print_count call 1-}print_count
count > 1 $ shrl
upper > -ceil beqz
print_count
-end jmp

:exit
0 $ exit

{0v}count {1v}peek
:skip_comment 10#
drop
getc
peek > eof xor -exit beqz
peek > putc
peek > cket xor -skip_comment bnez
drop
:core 1#
getc
{ count peek }
peek > eof xor -exit beqz
peek > putc
peek > brac xor -skip_comment beqz
001 $ 11010 & {':'} xor -core bnez
brac putc
count > print_count
1 $ add
010 $ 00000 & {'@'} putc
001 $ 00000 & {' '} putc
001 $ 10001 & {'1'} putc
001 $ 01011 & {'+'} putc
cket putc
001 $ 01101 & {'-'} putc
-core jmp

:main
0 $ -core jmp

{:entry}
-main jmp
