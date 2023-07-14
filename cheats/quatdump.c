#include <stdio.h>
int main(void)
{
    unsigned int n = 0;
    while (1) {
	int i, c;
	c = getchar();
	if (EOF == c)
	    return 0;
	for (i = 0; i < 4; i++) {
	    putchar((c >> 6 & 3) + '0');
	    c <<= 2;
	}
	putchar('b');
	{
	    char table[] = "   \n";
	    putchar(table[n]);
	}
	n = (n + 1) % 4;
    }
}
