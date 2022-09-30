/*
# hex
# comments begin with '#', end with '\n'.
3a 23   # '\s' is ignored.
# '\n' and '\t' are also ignored.
# each byte must be two nibble sequense.
# so, below example is invalid.
3 a23
# "$\n" boots what loaded.
3a 23  $
# so, this line and below is dealed with by what loaded.
*/
#include <stdio.h>
static int dehex_part(int base, int floor, int ceiling, char hex, int *rst)
{
    if (base > hex)
	return 0;
    hex += floor - base;
    if (ceiling <= hex)
	return 0;
    *rst = hex;
    return 1;
}
static int dehex(char hex, int *rst)
{
    return dehex_part('0', 0, 10, hex, rst)
	|| dehex_part('A', 10, 16, hex & ~0x20, rst);
}
static int get_key(int *peek)
{
    *peek = getchar();
    switch (*peek) {
    case ' ':
    case '\n':
    case '\t':
	return ' ';
    default:
	return *peek;
    }
}
int main(void)
{
    while (1) {
	int upper, lower, peek;
	switch (get_key(&peek)) {
	case ' ':
	    break;
	case '#':
	    while (1)
		switch (getchar()) {
		case '\n':
		    goto comment_done;
		case EOF:
		    return 1;
		}
	  comment_done:
	    break;
	case '$':
	    if ('\n' == getchar())
		return 0;
	    else
		return 1;
	default:
	    if (dehex(peek, &upper) && dehex(getchar(), &lower)
		&& ' ' == get_key(&peek)) {
		putchar((upper << 4) + lower);
		break;
	    }
	    return 1;
	}
    }
}
