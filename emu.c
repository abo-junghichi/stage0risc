#include <stdio.h>
#include <stdint.h>
/* Maximum where 16bit relative addressing is enough. */
#define MEM_SIZE (0x8000)
static uint32_t pc, reg[256];
static uint8_t mem[MEM_SIZE];
static int over_range(int byte, uint32_t vaddr)
{
    if (vaddr > ((uint32_t) MEM_SIZE) - byte)
	return 1;
    else
	return 0;
}
static int loadmem(int byte, uint32_t vaddr, uint32_t * dist)
{
    int i;
    uint32_t rtn = 0;
    if (over_range(byte, vaddr))
	return 1;
    for (i = 0; i < byte; i++)
	rtn |= mem[vaddr + i] << (8 * i);
    *dist = rtn;
    return 0;
}
static int storemem_bare(uint8_t * memory, int byte, uint32_t vaddr,
			 uint32_t src)
{
    int i;
    if (over_range(byte, vaddr))
	return 1;
    for (i = 0; i < byte; i++) {
	memory[vaddr + i] = src;
	src >>= 8;
    }
    return 0;
}
static int storemem(int byte, uint32_t vaddr, uint32_t src)
{
    return storemem_bare(mem, byte, vaddr, src);
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
    op_shll, op_shrl, op_shra,
    op_lb = 0x90, op_lbu, op_lw, op_lwu, op_ld,
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
	uint8_t *inst = &mem[pc];
	uint32_t npc = pc + 4;
	if ((pc % 4) || over_range(4, pc))
	    return 1;
#define S16 (((((uint32_t) ((int8_t) inst[3])) << 8)) + inst[2])
#define REL16 (pc + S16)
	switch (inst[0]) {
	case op_lit:
	    reg[inst[1]] = S16;
	    break;
	case op_rel:
	    reg[inst[1]] = REL16;
	    break;
	case op_jal:
	    reg[inst[1]] = npc;
	    npc = REL16;
	    break;
	case op_jalr:
	    reg[inst[2]] = npc;
	    npc = reg[inst[1]] + reg[inst[3]];
	    break;
#define CASE_BRANCH(name,op) case op_##name: if (reg[inst[1]] op 0) npc = REL16; break
	    CASE_BRANCH(beqz, ==);
	    CASE_BRANCH(bnez, !=);
#define CASE_ALU(name,op) case op_##name: reg[inst[2]] = reg[inst[1]] op reg[inst[3]]; break
	    CASE_ALU(add, +);
	    CASE_ALU(sub, -);
	    CASE_ALU(xor, ^);
	    CASE_ALU(or, |);
	    CASE_ALU(and, &);
#define CASE_SLT(name,cast) case op_##name: reg[inst[2]] = -(((cast) reg[inst[1]]) < ((cast) reg[inst[3]])); break
	    CASE_SLT(slt, int32_t);
	    CASE_SLT(sltu, uint32_t);
#define CASE_SHIFT(name,op) case op_##name: if (reg[inst[3]] > 31) reg[inst[2]] = 0; else reg[inst[2]] = reg[inst[1]] op reg[inst[3]]; break
	    CASE_SHIFT(shll, <<);
	    CASE_SHIFT(shrl, >>);
	case op_shra:
	    {
		uint32_t sign_bit = ((uint32_t) 0x1) << 31, shift =
		    reg[inst[3]];
		if (shift > 31)
		    shift = 31;
		reg[inst[2]] =
		    ((reg[inst[1]] ^ sign_bit) >> shift) -
		    (sign_bit >> shift);
	    }
	    break;
#define CASE_LOAD(name,byte,cast) case op_##name: { uint32_t tmp; if (loadmem(byte, reg[inst[3]] + inst[2], &tmp)) return 1; reg[inst[1]] = ((cast) tmp); } break
	    CASE_LOAD(lb, 1, int8_t);
	    CASE_LOAD(lbu, 1, uint8_t);
	    CASE_LOAD(lw, 2, int16_t);
	    CASE_LOAD(lwu, 2, uint16_t);
	    CASE_LOAD(ld, 4, int32_t);
#define CASE_STORE(name,byte) case op_##name: if (storemem(byte, reg[inst[3]] + inst[2], reg[inst[1]])) return 1; break;
	    CASE_STORE(sb, 1);
	    CASE_STORE(sw, 2);
	    CASE_STORE(sd, 4);
	case op_system:
	    if (0 != inst[1] || 0 != S16)
		return 1;
	    return 0;
	case op_getc:
	    if (0 != S16)
		return 1;
	    {
		int rst = fgetc(stdin);
		if (EOF == rst)
		    rst = -1;
		reg[inst[1]] = rst;
	    }
	    break;
	case op_putc:
	    if (0 != S16)
		return 1;
	    if (EOF == fputc(reg[inst[1]], stdout))
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
    int i;
    /*
       # assume header is 4byte.
       start:0x00
       lit %1 $1
       lit %8 $8
       getc %a
       getc %b
       getc %c
       getc %d
       shll %b %b %8
       or %a %a %b
       shll %d %d %8
       or %c %c %d
       lit %ff $16
       shll %c %c %ff
       or %a %a %c
       rel %d @data # @data = 0x1c
       jal %ff @branch # @branch = 0x14
       loop:0x40
       getc %c
       sb %c $0 %d
       add %d %d %1
       sub %a %a %1
       branch:0x50
       bnez %a @loop # @loop = -0x10 = 0xfff0
       data:0x54
     */
    uint8_t rom[0x50] = {
	op_lit, 0x01, 0x01, 0x00,
	op_lit, 0x08, 0x08, 0x00,
	op_getc, 0x0a, 0x0, 0x0,
	op_getc, 0x0b, 0x0, 0x0,
	op_getc, 0x0c, 0x0, 0x0,
	op_getc, 0x0d, 0x0, 0x0,
	op_shll, 0x0b, 0x0b, 0x08,
	op_or, 0x0a, 0x0a, 0x0b,
	op_shll, 0x0d, 0x0d, 0x08,
	op_or, 0x0c, 0x0c, 0x0d,
	op_lit, 0xfe, 0x10, 0x00,
	op_shll, 0x0c, 0x0c, 0xff,
	op_or, 0x0a, 0x0a, 0x0c,
	op_rel, 0x0d, 0x1c, 0x00,
	op_jal, 0xff, 0x14, 0x00,
	op_getc, 0x0c, 0x0, 0x0,
	op_sb, 0x0c, 0x00, 0x0d,
	op_add, 0x0d, 0x0d, 0x01,
	op_sub, 0x0a, 0x0a, 0x01,
	op_bnez, 0x0a, 0xf0, 0xff
    };
    for (i = 0; i < 0x50; i++)
	mem[i] = rom[i];
}
static void dump(void)
{
    FILE *errf = stderr;
    int i;
    uint8_t header[2048];
    for (i = 0; i < 2048; i++)
	header[i] = 0;
    storemem_bare(header, 4, 8, pc);
    for (i = 0; i < 256; i++)
	storemem_bare(header + 512, 4, i * 4, reg[i]);
    fwrite(header, 1, 2048, errf);
    fwrite(mem, 1, MEM_SIZE, errf);
}
int main(void)
{
    init();
    if (exec_vm())
	dump();
    return 0;
}
