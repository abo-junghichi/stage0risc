{001b 1-}<
{010b 1+}>
{011b 1+}$
{111b   }&

{00001 000b    }rel
{00010 000b  1-}jmpabs {jmp to absolute address}
{00011 000b  1-}callabs
{00100 000b 10-}beqzabs
{00101 000b 10-}bnezabs
{00110 000b  1-}drop
{00111 000b  1-}drops {needs more stack-indication}
{01000 000b  1-}piles {needs more stack-indication}
{01001 000b  1-}set_gp
{01010 000b  1+}get_gp
{01011 000b    }pick
{01100 000b 10-}bury
{01101 000b  1-}add
{01110 000b  1-}sub
{01111 000b  1-}xor
{10000 000b  1-}or
{10001 000b  1-}and
{10010 000b  1-}slt
{10011 000b  1-}sltu
{10100 000b  1-}shl
{10101 000b  1-}shrl
{10110 000b  1-}shra
{10111 000b    }lb
{11000 000b    }lw
{11001 000b    }ld
{11010 000b 10-}sb
{11011 000b 10-}sw
{11100 000b 10-}sd
{11101 000b  1+}getc
{11110 000b  1-}putc
{11111 000b  1-}exit

{jmpabs}ret
{rel jmpabs}jmp
{rel callabs}call
{rel beqzabs}beqz
{rel bnezabs}bnez
