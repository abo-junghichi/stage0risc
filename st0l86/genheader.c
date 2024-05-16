#include <stdio.h>
static void patch(char *addr, unsigned int num)
{
    int i;
    for (i = 0; i < 4; i++) {
	addr[i] = num;
	num >>= 8;
    }
}
int main(void)
{
    char header[] = {
	/* elf header */
	 /**/ 0x7f, 'E', 'L', 'F', 1, 1, 1, 0,
	 /**/ 0, 0, 0, 0, 0, 0, 0, 0,
	 /**/ 2, 0, 3, 0,
	 /**/ 1, 0, 0, 0,
	/* entry point */ 0, 0, 0, 0,
	 /**/ 52, 0, 0, 0,
	 /**/ 0, 0, 0, 0, 0, 0, 0, 0,
	 /**/ 52, 0, 0x20, 0, 2, 0,
	 /**/ 0, 0, 0, 0, 0, 0,
	/* program header */
	/* text page */
	/* type load */ 1, 0, 0, 0,
	/* offset */ 0, 0, 0, 0,
	/* virtual address */ 0, 0x10, 0, 0,
	/* physical address */ 0, 0x10, 0, 0,
	/* file size */ 0, 0, 0, 0,
	/* memory size */ 0, 0, 0, 0,
	/* flags */ 5, 0, 0, 0,
	/* align */ 0, 0x10, 0, 0,
	/* bss page */
	/* type load */ 1, 0, 0, 0,
	/* offset */ 0, 0, 0, 0,
	/* virtual address */ 0, 0, 1, 0,
	/* physical address */ 0, 0, 1, 0,
	/* unused file size */ 0, 0, 0, 0,
	/* memory size */ 0, 0, 1, 0,
	/* flags */ 6, 0, 0, 0,
	/* align */ 0, 0x10, 0, 0
    };
    unsigned int text = 0x1000, size = 0, entry;
    while (1) {
	if (EOF == getchar())
	    break;
	size++;
    }
    size += sizeof(header);
    entry = size + (text - 5);
    patch(header + 24, entry);
    patch(header + 60, text);
    patch(header + 64, text);
    patch(header + 68, size);
    patch(header + 72, size);
    fwrite(header, sizeof(header), 1, stdout);
    return 0;
}
