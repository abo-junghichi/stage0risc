#include <stdio.h>
static unsigned int stack[10000];
int main(void)
{
    unsigned int imm = 0, pos = 0, /* stack height of runtime */ shr = 0;
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
	    putchar((imm & 0x7) << 5 | (imm >> 3 & 0x1f));
	    pos++;
	    goto immzero;
	case ':':
	    *sp++ = pos;
	    break;
	case '@':
	    pos += 2;
	    imm = stack[imm] - pos;
	    putchar(0x60 | (imm >> 5 & 0x1f));
	    putchar(0xe0 | (imm & 0x1f));
	    goto immzero;
	case '#':
	    shr = imm;
	    goto immzero;
	case '+':
	    shr += imm;
	    goto immzero;
	case '-':
	    shr -= imm;
	    goto immzero;
	case 'v':
	    imm = shr - imm - 1;
	    break;
	case EOF:
	    if (!imm)
		return 0;
	default:
	    return 1;
	}
	continue;
      immzero:
	imm = 0;
    }
}
