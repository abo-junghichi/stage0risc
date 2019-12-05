/*
# hex
# comments begin with '#', end with '\n'.
3a 23   # '\s' is ignored.
# '\n' is also ignored.
3a23 # same bytes as above.
# each byte must be two nibble sequense.
# so, below example is invalid.
3 a23
# "$\n" boots what loaded.
3a 23  $
# so, this line and below is dealed with by what loaded.
*/
#include <stdio.h>
static int hex(int c, int *rst)
{
    if (c >= '0' && c <= '9') {
	*rst = c - '0';
	return 1;
    } else if (c >= 'a' && c <= 'f') {
	*rst = c - 'a' + 10;
	return 1;
    }
    return 0;
}
int main(void)
{
    while (!0) {
	int upper, lower, c = getchar();
	if (hex(c, &upper)) {
	    c = getchar();
	    if (hex(c, &lower)) {
		putchar((upper << 4) + lower);
		continue;
	    } else
		return 1;
	}
	switch (c) {
	case '#':
	    while (!0) {
		c = getchar();
		if ('\n' == c)
		    break;
		else if (EOF == c)
		    return 1;
	    }
	    break;
	case ' ':
	case '\n':
	    break;
	case '$':
	    {
		c = getchar();
		if ('\n' == c)
		    return 0;
		else
		    return 1;
	    }
	default:
	    return 1;
	}
    }
    return 1;
}
