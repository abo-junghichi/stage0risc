#include <stdio.h>
typedef struct {
    int c;
    int is_delim, is_eof;
} peek;
static peek getpeek(void)
{
    int i;
    peek p;
    int delim[5] = { ' ', '\n', '{', '}', EOF };
    p.c = fgetc(stdin);
    for (i = 0; i < 5; i++)
	if (delim[i] == p.c) {
	    p.is_delim = 1;
	    goto done;
	}
    p.is_delim = 0;
  done:
    p.is_eof = EOF == p.c ? 1 : 0;
    return p;
}
static void putpeek(peek p)
{
    if (p.is_eof)
	return;
    fputc(p.c, stdout);
}
static peek putrest(peek p)
{
    while (1) {
	putpeek(p);
	if (p.is_delim)
	    break;
	p = getpeek();
    }
    return p;
}
static peek tryswap(peek f, int dist)
{
    peek s;
    s = getpeek();
    if (s.is_delim)
	f.c = dist;
    putpeek(f);
    return putrest(s);
}
int main(void)
{
    peek f;
    do {
	f = getpeek();
	if ('+' == f.c)
	    f = tryswap(f, '&');
	else
	    f = putrest(f);
    } while (!f.is_eof);
}
