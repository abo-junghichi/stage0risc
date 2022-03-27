#include <stdio.h>
static int convbyte(const char *delim)
{
    int c = fgetc(stdin);
    if (EOF == c)
	return 0;
    printf("%s0x%02x", delim, c);
    return 1;
}
int main(void)
{
    int cf;
    /* skip img-header. */
    for (cf = 0; cf < 4; cf++)
	fgetc(stdin);
    printf("uint8_t rom[] = {\n");
    cf = convbyte("");
    while (cf)
	cf = convbyte(", ");
    printf("\n};\n");
    return 0;
}
