#include <stdio.h>
#include <stdint.h>
#include "rom.c"
/* Maximum where 16bit relative addressing is enough. */
#define MEM_SIZE (0x2000)
static uint32_t pc, regfile[256], mem[MEM_SIZE + 1];
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
static unsigned int movzblh(int arg)
{
    unsigned int rtn;
  asm("movzbl %h1, %0": "=r"(rtn):"Q"(arg));
    return rtn;
}
static unsigned int movzbll(int arg)
{
    unsigned int rtn;
  asm("movzbl %b1, %0": "=r"(rtn):"q"(arg));
    return rtn;
}
static int exec_vm(void)
{
    int rtn;
    int s16;
    unsigned int f1, f2, f3;
    register uint32_t inst asm("ecx");
    register uint32_t *lpc asm("esi");
    register uint32_t *reg asm("edi") = regfile;
#include "label.c"
#define RETURN(ret) { rtn = ret; goto end; }
#define TWO_OP asm("movzbl %h0, %1\n\t" "sarl $16, %0": "=Q"(s16), "=&r"(f1):"0"(inst))
#define THREE_OP asm("movzbl %h2, %0\n\t" "shrl $16, %2\n\t" "movzbl %b2, %1\n\t" "movzbl %h2, %2": "=&r"(f1), "=&r"(f2), "=Q"(f3):"2"(inst))
#define S16 (s16)
#define REL16 ((lpc - mem) * 4 + S16)
#define FIELD1 (f1)
#define FIELD2 (f2)
#define FIELD3 (f3)
#define GUARD_stringify_core(num) #num
#define GUARD_stringify(num_macro) GUARD_stringify_core(num_macro)
#define GUARD __asm__("/* " __FILE__ " " GUARD_stringify(__LINE__) " */")
#define NEXT_CORE asm goto ("movl (%1), %0\n\t" "movzbl %b0, %%eax\n\t" "jmp *28(%%esp,%%eax,4)\n\t" "/*" GUARD_stringify(__LINE__) "*/":"=q" (inst):"r"(lpc):"eax":next); __builtin_unreachable()
//#define NEXT_CORE asm ("movl (%1), %0\n\t" "movzbl %b0, %%eax\n\t" "jmp *(%2,%%eax,4)\n\t" "/*" GUARD_stringify(__LINE__) "*/":"=q" (inst):"r"(lpc), "r"(label):"eax"); goto next
//#define NEXT_CORE inst = *lpc; GUARD; goto next
#define NEXT lpc++; NEXT_CORE
    if (bad_addr(4, pc))
	return 1;
    lpc = &mem[pc / 4];
    mem[MEM_SIZE] = 0 /* sentinel */ ;
    inst = *lpc;
  next:
    goto *label[inst & 0xff];
#define CASE(name) l_##name
  CASE(lit):
    TWO_OP;
    reg[FIELD1] = S16;
    NEXT;
  CASE(rel):
    TWO_OP;
    reg[FIELD1] = REL16;
    NEXT;
#define JMP(addr) uint32_t vpc = (addr), *tpc; if (bad_addr(4, vpc)) RETURN(1); tpc = (uint32_t *) ((char *) mem + vpc)
#define RELJMP JMP(REL16)
  CASE(jal):
    TWO_OP;
    {
	RELJMP;
	reg[FIELD1] = (lpc + 1 - mem) * 4;
	lpc = tpc;
    }
    NEXT_CORE;
  CASE(jalr):
    THREE_OP;
    {
	JMP(reg[FIELD1] + reg[FIELD3]);
	reg[FIELD2] = (lpc + 1 - mem) * 4;
	lpc = tpc;
    }
    NEXT_CORE;
#define CASE_BRANCH(name,op) CASE(name): asm("movzbl %h1, %0": "=r"(f1):"Q"(inst)); if (reg[FIELD1] op 0) goto branch; else goto nop
  branch:
  asm("sarl $16, %0": "=r"(s16):"0"(inst));
    {
	RELJMP;
	lpc = tpc;
    }
    NEXT_CORE;
  nop:
    NEXT;
    CASE_BRANCH(beqz, ==);
    CASE_BRANCH(bnez, !=);
#define CASE_ALU(name,op) CASE(name): THREE_OP; reg[FIELD2] = reg[FIELD1] op reg[FIELD3]; NEXT
    CASE_ALU(add, +);
    CASE_ALU(sub, -);
    CASE_ALU(xor, ^);
    CASE_ALU(or, |);
    CASE_ALU(and, &);
#define CASE_SLT(name,cast) CASE(name): THREE_OP; reg[FIELD2] = -(((cast) reg[FIELD1]) < ((cast) reg[FIELD3])); NEXT
    CASE_SLT(slt, int32_t);
    CASE_SLT(sltu, uint32_t);
#define SHIFT_MASK ((0x1 << 5) - 1)
#define CASE_SHIFT(name,cast,op) CASE(name): THREE_OP; reg[FIELD2] = ((cast) reg[FIELD1]) op (reg[FIELD3] & SHIFT_MASK); NEXT
    CASE_SHIFT(shl, uint32_t, <<);
    CASE_SHIFT(shrl, uint32_t, >>);
    /* gcc treats shift-right on signed with sign extension.
     * See [ info gcc -> C Implementation -> Integers implementation ]. */
    CASE_SHIFT(shra, int32_t, >>);
#define CASE_LOAD(name,byte,cast) CASE(name): THREE_OP; { uint32_t tmp; if (loadmem(byte, reg[FIELD3] + FIELD2, &tmp)) RETURN(1); reg[FIELD1] = ((cast) tmp); } NEXT
    CASE_LOAD(lb, 1, int8_t);
    CASE_LOAD(lw, 2, int16_t);
  CASE(ld):
    THREE_OP;
    {
	uint32_t vaddr = reg[FIELD3] + FIELD2;
	if (bad_addr(4, vaddr))
	    RETURN(1);
	reg[FIELD1] = mem[vaddr / 4];
    }
    NEXT;
#define CASE_STORE(name,byte) CASE(name): THREE_OP; if (storemem(byte, reg[FIELD3] + FIELD2, reg[FIELD1])) RETURN(1); NEXT
    CASE_STORE(sb, 1);
    CASE_STORE(sw, 2);
  CASE(sd):
    THREE_OP;
    {
	uint32_t vaddr = reg[FIELD3] + FIELD2;
	if (bad_addr(4, vaddr))
	    RETURN(1);
	mem[vaddr / 4] = reg[FIELD1];
    }
    NEXT;
  CASE(system):
    TWO_OP;
    if (0 != FIELD1 || 0 != S16)
	RETURN(1);
    RETURN(0);
  CASE(getc):
    TWO_OP;
    if (0 != S16)
	RETURN(1);
    {
	int rst = fgetc(stdin);
	if (EOF == rst)
	    rst = -1;
	reg[FIELD1] = rst;
    }
    NEXT;
  CASE(putc):
    TWO_OP;
    if (0 != S16)
	RETURN(1);
    if (EOF == fputc(reg[FIELD1], stdout))
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
	header[128 + i] = regfile[i];
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
