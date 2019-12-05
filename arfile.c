#include <stdio.h>
#include <stdlib.h>
#define HEADER_SIZE (4)
typedef struct {
    size_t room, used;
    char *cont;
} char_buf;
static int swallow_file(FILE * f, char_buf * bufp)
{
    int rtn = 0;
    char_buf buf = *bufp;
    buf.used = 0;
    while (1) {
	int c = getc(f);
	if (EOF == c)
	    break;
	if (buf.room <= buf.used) {
	    char_buf newbuf = buf;
	    newbuf.room = buf.room * 2;
	    newbuf.cont = realloc(buf.cont, newbuf.room);
	    if (NULL == newbuf.cont) {
		rtn = 1;
		break;
	    }
	    buf = newbuf;
	}
	buf.cont[buf.used] = c;
	buf.used++;
    }
    *bufp = buf;
    return rtn;
}
int main(int argc, char **argv)
{
    char_buf buf;
    buf.room = 1;
    buf.cont = malloc(1);
    for (argv++; NULL != *argv; argv++) {
	int i;
	size_t length;
	char lenbuf[HEADER_SIZE];
	FILE *f = fopen(*argv, "rb");
	if (swallow_file(f, &buf))
	    return 1;
	length = buf.used;
	for (i = 0; i < HEADER_SIZE; i++) {
	    lenbuf[i] = length;
	    length >>= 8;
	}
	if (length)
	    return 1;
	if (HEADER_SIZE != fwrite(lenbuf, 1, HEADER_SIZE, stdout))
	    return 1;
	if (buf.used != fwrite(buf.cont, 1, buf.used, stdout))
	    return 1;
	fclose(f);
    }
    return 0;
}
