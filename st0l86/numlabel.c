#include <stdio.h>
unsigned int stack[10000];
int main(void)
{
    int i;
    unsigned int imm = 0, pos = 0;
    unsigned int *sp = stack;
    while (1) {
	int peek = getchar();
	switch (peek) {
	case ' ':
	case '\n':
	    break;
	case '0':
	case '1':
	    imm = imm << 1 | (peek - '0');
	    break;
	case 'b':
	    putchar(imm);
	    pos++;
	    imm = 0;
	    break;
	case ':':
	    *sp++ = pos;
	    break;
	case '@':
	    pos += 4;
	    imm = stack[imm] - pos;
	    for (i = 0; i < 4; i++) {
		putchar(imm);
		imm >>= 8;
	    }
	    imm = 0;
	    break;
	case EOF:
	    if (!imm)
		return 0;
	default:
	    return 1;
	}
    }
}
