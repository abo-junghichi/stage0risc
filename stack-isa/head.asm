{001b}<
{010b}>
{011b}$
{111b}+

{00001 000b}rel
{00010 000b}jmpabs {jmp to absolute address}
{00011 000b}callabs
{00100 000b}beqzabs
{00101 000b}bnezabs
{00110 000b}drop
{00111 000b}drops
{01000 000b}piles
{01001 000b}set_gp
{01010 000b}get_gp
{01011 000b}pick
{01100 000b}bury
{01101 000b}add
{01110 000b}sub
{01111 000b}xor
{10000 000b}or
{10001 000b}and
{10010 000b}slt
{10011 000b}sltu
{10100 000b}shl
{10101 000b}shrl
{10110 000b}shra
{10111 000b}lb
{11000 000b}lw
{11001 000b}ld
{11010 000b}sb
{11011 000b}sw
{11100 000b}sd
{11101 000b}getc
{11110 000b}putc
{11111 000b}exit

{jmpabs}ret
{rel jmpabs}jmp
{rel callabs}call
{rel beqzabs}beqz
{rel bnezabs}bnez
