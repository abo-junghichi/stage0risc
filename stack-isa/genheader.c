#include <stdio.h>
int main(void)
{
    unsigned int i, size = 0, tmp;
    while (1) {
	if (EOF == getchar())
	    break;
	size++;
    }
    tmp = size + 4;
    for (i = 0; i < 4; i++) {
	putchar(tmp);
	tmp >>= 8;
    }
    tmp = size - 4 + 2;
    putchar(0x60 | (tmp >> 5 & 0x1f));
    putchar(0xe0 | (tmp & 0x1f));
    putchar( /* op_rel */ 0x01);
    putchar( /* op_jmp */ 0x02);
    return 0;
}
