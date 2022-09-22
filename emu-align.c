#include <stdio.h>
#include <stdint.h>
#include "rom.c"
/* Maximum where 16bit relative addressing is enough. */
#define MEM_SIZE (0x2000)
static uint32_t pc, reg[256], mem[MEM_SIZE];
static int bad_addr(int byte, uint32_t vaddr)
{
    return (vaddr % byte) || ((vaddr / 4) >= MEM_SIZE);
}
static int loadmem(int byte, uint32_t vaddr, uint32_t * dist)
{
    uint32_t div = vaddr / 4, rem = vaddr % 4;
    if (bad_addr(byte, vaddr))
	return 1;
    *dist =
	(mem[div] >> (8 * rem)) & ((((uint32_t) 0x1) << (8 * byte)) - 1);
    return 0;
}
static int storemem(int byte, uint32_t vaddr, uint32_t src)
{
    uint32_t div = vaddr / 4, rem = vaddr % 4, shift = 8 * rem, mask =
	(((uint32_t) 0x1) << (8 * byte)) - 1;
    if (bad_addr(byte, vaddr))
	return 1;
    mem[div] = (mem[div] & ~(mask << shift)) | ((src & mask) << shift);
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
static int exec_vm(void)
{
    while (1) {
	uint32_t inst = mem[pc / 4];
	uint32_t npc = pc + 4;
	if (bad_addr(4, pc))
	    return 1;
#define S16 ((int16_t) (inst >> 16))
#define REL16 (pc + S16)
#define FIELD(field) ((inst >> (8 * field)) & 0xff)
	switch (FIELD(0)) {
	case op_lit:
	    reg[FIELD(1)] = S16;
	    break;
	case op_rel:
	    reg[FIELD(1)] = REL16;
	    break;
	case op_jal:
	    reg[FIELD(1)] = npc;
	    npc = REL16;
	    break;
	case op_jalr:
	    reg[FIELD(2)] = npc;
	    npc = reg[FIELD(1)] + reg[FIELD(3)];
	    break;
#define CASE_BRANCH(name,op) case op_##name: if (reg[FIELD(1)] op 0) npc = REL16; break
	    CASE_BRANCH(beqz, ==);
	    CASE_BRANCH(bnez, !=);
#define CASE_ALU(name,op) case op_##name: reg[FIELD(2)] = reg[FIELD(1)] op reg[FIELD(3)]; break
	    CASE_ALU(add, +);
	    CASE_ALU(sub, -);
	    CASE_ALU(xor, ^);
	    CASE_ALU(or, |);
	    CASE_ALU(and, &);
#define CASE_SLT(name,cast) case op_##name: reg[FIELD(2)] = -(((cast) reg[FIELD(1)]) < ((cast) reg[FIELD(3)])); break
	    CASE_SLT(slt, int32_t);
	    CASE_SLT(sltu, uint32_t);
#define SHIFT_MASK ((0x1 << 5) - 1)
#define CASE_SHIFT(name,op) case op_##name: reg[FIELD(2)] = reg[FIELD(1)] op (reg[FIELD(3)] & SHIFT_MASK); break
	    CASE_SHIFT(shl, <<);
	    CASE_SHIFT(shrl, >>);
	case op_shra:
	    {
		uint32_t sign_bit = ((uint32_t) 0x1) << 31, shift =
		    reg[FIELD(3)] & SHIFT_MASK;
		reg[FIELD(2)] =
		    ((reg[FIELD(1)] ^ sign_bit) >> shift) -
		    (sign_bit >> shift);
	    }
	    break;
#define CASE_LOAD(name,byte,cast) case op_##name: { uint32_t tmp; if (loadmem(byte, reg[FIELD(3)] + FIELD(2), &tmp)) return 1; reg[FIELD(1)] = ((cast) tmp); } break
	    CASE_LOAD(lb, 1, int8_t);
	    CASE_LOAD(lw, 2, int16_t);
	case op_ld:
	    {
		uint32_t vaddr = reg[FIELD(3)] + FIELD(2);
		if (bad_addr(4, vaddr))
		    return 1;
		reg[FIELD(1)] = mem[vaddr / 4];
	    }
	    break;
#define CASE_STORE(name,byte) case op_##name: if (storemem(byte, reg[FIELD(3)] + FIELD(2), reg[FIELD(1)])) return 1; break;
	    CASE_STORE(sb, 1);
	    CASE_STORE(sw, 2);
	case op_sd:
	    {
		uint32_t vaddr = reg[FIELD(3)] + FIELD(2);
		if (bad_addr(4, vaddr))
		    return 1;
		mem[vaddr / 4] = reg[FIELD(1)];
	    }
	    break;
	case op_system:
	    if (0 != FIELD(1) || 0 != S16)
		return 1;
	    return 0;
	case op_getc:
	    if (0 != S16)
		return 1;
	    {
		int rst = fgetc(stdin);
		if (EOF == rst)
		    rst = -1;
		reg[FIELD(1)] = rst;
	    }
	    break;
	case op_putc:
	    if (0 != S16)
		return 1;
	    if (EOF == fputc(reg[FIELD(1)], stdout))
		return 1;
	    break;
	case 0x00:
	case 0xff:
	default:
	    return 1;
	}
	pc = npc;
    }
}
static void init(void)
{
    size_t i;
    for (i = 0; i < sizeof(rom); i++)
	storemem(1, i, rom[i]);
}
static void dump(void)
{
    FILE *errf = stderr;
    int i;
    uint32_t header[512];
    for (i = 0; i < 512; i++)
	header[i] = 0;
    header[2] = pc;
    for (i = 0; i < 256; i++)
	header[128 + i] = reg[i];
    fwrite(header, 4, 512, errf);
    fwrite(mem, 4, MEM_SIZE, errf);
}
int main(void)
{
    init();
    if (exec_vm())
	dump();
    return 0;
}
