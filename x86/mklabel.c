#include <stdio.h>
#include <stdint.h>
static const char *op_name[256];
static unsigned int op_enum = 0;
static void label_set(uint8_t code, const char *mnemonic)
{
    op_name[code] = mnemonic;
    op_enum = code + 1;
}
int main(void)
{
    unsigned int i;
    const char *head;
#define LABEL_START(code,mnemonic) label_set(code, "l_" #mnemonic);
#define LABEL(mnemonic) label_set(op_enum++, "l_" #mnemonic);
    for (i = 0; i < 256; i++)
	op_name[i] = "sentinel";
    LABEL_START(0x80, lit);
    LABEL(rel);
    LABEL(jal);
    LABEL(jalr);
    LABEL(beqz);
    LABEL(bnez);
    LABEL(add);
    LABEL(sub);
    LABEL(xor);
    LABEL(or);
    LABEL(and);
    LABEL(slt);
    LABEL(sltu);
    LABEL(shl);
    LABEL(shrl);
    LABEL(shra);
    LABEL_START(0x90, lb);
    LABEL(lw);
    LABEL(ld);
    LABEL(sb);
    LABEL(sw);
    LABEL(sd);
    LABEL_START(0xa0, system);
    LABEL(getc);
    LABEL(putc);
    head = "const void *label[256] = {\n ";
    for (i = 0; i < 256; i++) {
	printf("%s/*%02x*/&&%s\n", head, i, op_name[i]);
	head = ",";
    }
    printf("};\n");
    return 0;
}
typedef enum {
    /* 16 byte instructions 1110-XXXX */
    /* 8 byte instructions 110X-XXXX op_lit32 */
    /* 4 byte instructions 10XX-XXXX */
    /* primitive */
    op_lit = 0x80, op_rel, op_jal, op_jalr,
    op_beqz, op_bnez,
    op_add, op_sub,
    op_xor, op_or, op_and,
    op_slt, op_sltu,
    op_shl, op_shrl, op_shra,
    op_lb = 0x90, op_lw, op_ld,
    op_sb, op_sw, op_sd,
    /* system */
    op_system = 0xa0, op_getc, op_putc
	/* 2 byte instructions 01XX-XXXX
	   op_nopw = 0x20, op_getc_w, op_putc_w */
	/* 1 byte instructions 00XX-XXXX (!=0) op_nop */
} op_code;
