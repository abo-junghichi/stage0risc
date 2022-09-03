#include <stdio.h>
#include <stdint.h>
#include "rom.c"
/* Maximum where 16bit relative addressing is enough. */
#define MEM_SIZE (0x2000)
static uint32_t pc, reg[256], mem[MEM_SIZE + 1];
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
    int rtn, i;
    uint32_t inst;
    uint32_t *lpc;
    void *label[256];
#define RETURN(ret) { rtn = ret; goto end; }
#define S16 ((int16_t) (inst >> 16))
#define REL16 ((lpc - mem) * 4 + S16)
#define FIELD(field) ((inst >> (8 * field)) & 0xff)
#define GUARD_stringify_core(num) #num
#define GUARD_stringify(num_macro) GUARD_stringify_core(num_macro)
#define GUARD __asm__("/* " __FILE__ " " GUARD_stringify(__LINE__) " */")
#define NEXT_CORE inst = *lpc; GUARD; goto *label[FIELD(0)]
#define NEXT lpc++; NEXT_CORE
    if (bad_addr(4, pc))
	return 1;
    for (i = 0; i < 256; i++)
	label[i] = &&sentinel;
#define LABEL(name) label[op_##name] = && l_##name
    LABEL(lit);
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
    LABEL(lb);
    LABEL(lw);
    LABEL(ld);
    LABEL(sb);
    LABEL(sw);
    LABEL(sd);
    LABEL(system);
    LABEL(getc);
    LABEL(putc);
    lpc = &mem[pc / 4];
    mem[MEM_SIZE] = 0 /* sentinel */ ;
    NEXT_CORE;
  l_lit:
    reg[FIELD(1)] = S16;
    NEXT;
  l_rel:
    reg[FIELD(1)] = REL16;
    NEXT;
#define JMP(addr) uint32_t vpc = (addr), *tpc; if (bad_addr(4, vpc)) RETURN(1); tpc = &mem[vpc / 4]
#define RELJMP JMP(REL16)
  l_jal:
    {
	RELJMP;
	reg[FIELD(1)] = (lpc + 1 - mem) * 4;
	lpc = tpc;
    }
    NEXT_CORE;
  l_jalr:
    {
	JMP(reg[FIELD(1)] + reg[FIELD(3)]);
	reg[FIELD(2)] = (lpc + 1 - mem) * 4;
	lpc = tpc;
    }
    NEXT_CORE;
#define CASE_BRANCH(name,op) l_##name: if (reg[FIELD(1)] op 0) goto branch; else goto nop
  branch:
    {
	RELJMP;
	lpc = tpc;
    }
    NEXT_CORE;
  nop:
    NEXT;
    CASE_BRANCH(beqz, ==);
    CASE_BRANCH(bnez, !=);
#define CASE_ALU(name,op) l_##name: reg[FIELD(2)] = reg[FIELD(1)] op reg[FIELD(3)]; NEXT
    CASE_ALU(add, +);
    CASE_ALU(sub, -);
    CASE_ALU(xor, ^);
    CASE_ALU(or, |);
    CASE_ALU(and, &);
#define CASE_SLT(name,cast) l_##name: reg[FIELD(2)] = -(((cast) reg[FIELD(1)]) < ((cast) reg[FIELD(3)])); NEXT
    CASE_SLT(slt, int32_t);
    CASE_SLT(sltu, uint32_t);
#define SHIFT_MASK ((0x1 << 5) - 1)
#define CASE_SHIFT(name,cast,op) l_##name: reg[FIELD(2)] = ((cast) reg[FIELD(1)]) op (reg[FIELD(3)] & SHIFT_MASK); NEXT
    CASE_SHIFT(shl, uint32_t, <<);
    CASE_SHIFT(shrl, uint32_t, >>);
    /* gcc treats shift-right on signed with sign extension.
     * See [ info gcc -> C Implementation -> Integers implementation ]. */
    CASE_SHIFT(shra, int32_t, >>);
#define CASE_LOAD(name,byte,cast) l_##name: { uint32_t tmp; if (loadmem(byte, reg[FIELD(3)] + FIELD(2), &tmp)) RETURN(1); reg[FIELD(1)] = ((cast) tmp); } NEXT
    CASE_LOAD(lb, 1, int8_t);
    CASE_LOAD(lw, 2, int16_t);
    CASE_LOAD(ld, 4, int32_t);
#define CASE_STORE(name,byte) l_##name: if (storemem(byte, reg[FIELD(3)] + FIELD(2), reg[FIELD(1)])) RETURN(1); NEXT
    CASE_STORE(sb, 1);
    CASE_STORE(sw, 2);
  l_sd:
    {
	uint32_t vaddr = reg[FIELD(3)] + FIELD(2);
	if (bad_addr(4, vaddr))
	    RETURN(1);
	mem[vaddr / 4] = reg[FIELD(1)];
    }
    NEXT;
  l_system:
    if (0 != FIELD(1) || 0 != S16)
	RETURN(1);
    RETURN(0);
  l_getc:
    if (0 != S16)
	RETURN(1);
    {
	int rst = fgetc(stdin);
	if (EOF == rst)
	    rst = -1;
	reg[FIELD(1)] = rst;
    }
    NEXT;
  l_putc:
    if (0 != S16)
	RETURN(1);
    if (EOF == fputc(reg[FIELD(1)], stdout))
	RETURN(1);
    NEXT;
    /* case 0x00: case 0xff: default: */
  sentinel:
    RETURN(1);
  end:
    pc = (lpc - mem) * 4;
    return rtn;
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
