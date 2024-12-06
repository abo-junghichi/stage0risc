#include <stdio.h>
#include <stdint.h>
#define MEM_SIZE (0x2000)
#define WORD_SIZE (sizeof(uint32_t))
typedef union {
    uint32_t w;
    uint8_t b[WORD_SIZE];
} word;
static word mem[MEM_SIZE];
enum { rtn_succ = 0, rtn_addr, rtn_stack, rtn_misc };
static int rtn;
static uint32_t pc_next, gp, sp;
static int bad_addr(int byte, uint32_t vaddr)
{
    if ((vaddr % byte) || (vaddr / sizeof(uint32_t) >= sp)) {
	rtn = rtn_addr;
	return 1;
    }
    return 0;
}
static int loadmem(int byte, uint32_t vaddr, uint32_t *dist)
{
    int i;
    uint32_t div = vaddr / 4, rem = vaddr % 4;
    if (bad_addr(byte, vaddr))
	return 1;
    *dist = 0;
    for (i = 0; i < byte; i++)
	*dist = *dist | mem[div].b[rem + i] << 8 * i;
    return 0;
}
static int storemem(int byte, uint32_t vaddr, uint32_t src)
{
    int i;
    uint32_t div = vaddr / 4, rem = vaddr % 4;
    if (bad_addr(byte, vaddr))
	return 1;
    for (i = 0; i < byte; i++) {
	mem[div].b[rem + i] = src;
	src >>= 8;
    }
    return 0;
}
static int pop(uint32_t *tos)
{
    if (MEM_SIZE <= sp) {
	rtn = rtn_stack;
	return 1;
    }
    *tos = mem[sp++].w;
    return 0;
}
static int pick_core(uint32_t arg)
{
    uint32_t slot = sp + arg;
    if (MEM_SIZE - sp <= arg) {
	rtn = rtn_stack;
	return 1;
    }
    mem[--sp]
	= mem[slot];
    return 0;
}
static int op_pick(void)
{
    uint32_t arg;
    if (pop(&arg))
	return 1;
    return pick_core(arg);
}
static int op_drop(void)
{
    uint32_t dummy;
    return pop(&dummy);
}
static int op_drops(void)
{
    uint32_t arg;
    if (pop(&arg))
	return 1;
    if (MEM_SIZE - sp < arg) {
	rtn = rtn_stack;
	return 1;
    }
    sp += arg;
    return 0;
}
static int op_piles(void)
{
    uint32_t arg;
    if (pop(&arg))
	return 1;
    if (sp < arg) {
	rtn = rtn_misc;
	return 1;
    }
    sp -= arg;
    return 0;
}
static int bury_core(uint32_t arg)
{
    uint32_t slot = sp + arg + 1;
    if (MEM_SIZE - sp <= arg + 1) {
	rtn = rtn_stack;
	return 1;
    } else
	mem[slot] = mem[sp++];
    return 0;
}
static int op_bury(void)
{
    uint32_t arg;
    if (pop(&arg))
	return 1;
    return bury_core(arg);
}
static int op_load_core(int byte, uint32_t(*sign_ext) (uint32_t))
{
    uint32_t vaddr, value;
    if (pop(&vaddr) || loadmem(byte, vaddr, &value))
	return 1;
    mem[--sp].w = sign_ext(value);
    return 0;
}
static int op_store_core(int byte)
{
    uint32_t vaddr, value;
    if (pop(&vaddr) || pop(&value) || storemem(byte, vaddr, value))
	return 1;
    return 0;
}
#define OP_MEMORY(byte,cast,suffix) \
static uint32_t sign_ext_##suffix(uint32_t uns) { return (cast) uns; }\
static int op_l##suffix(void) { return op_load_core(byte,sign_ext_##suffix); }\
static int op_s##suffix(void) { return op_store_core(byte); }
OP_MEMORY(1, int8_t, b);
OP_MEMORY(2, int16_t, w);
OP_MEMORY(4, int32_t, d);
static int op_rel(void)
{
    mem[sp].w = mem[sp].w + pc_next - 1;
    return 0;
}
static int op_call(void)
{
    uint32_t vaddr;
    if (pop(&vaddr) || bad_addr(1, vaddr))
	return 1;
    mem[--sp].w = pc_next;
    pc_next = vaddr;
    return 0;
}
static int op_jmp(void)
{
    uint32_t vaddr;
    if (pop(&vaddr) || bad_addr(1, vaddr))
	return 1;
    pc_next = vaddr;
    return 0;
}
static int op_set_gp(void)
{
    uint32_t vaddr;
    if (pop(&vaddr))
	return 1;
    gp = vaddr;
    return 0;
}
static int op_get_gp(void)
{
    mem[--sp].w = gp;
    return 0;
}
static int op_branch_core(int beqz)
{
    uint32_t flag, vaddr;
    if (pop(&vaddr) || pop(&flag))
	return 1;
    if (beqz) {
	if (0 == flag)
	    goto jmp;
    } else {
	if (0 != flag)
	    goto jmp;
    }
  end:
    return 0;
  jmp:
    if (bad_addr(1, vaddr))
	return 1;
    pc_next = vaddr;
    goto end;
}
static int op_beqz(void)
{
    return op_branch_core(1);
}
static int op_bnez(void)
{
    return op_branch_core(0);
}
static int op_arith_core(uint32_t(*alu) (uint32_t, uint32_t))
{
    uint32_t ee, er;
    if (pop(&er) || pop(&ee))
	return 1;
    mem[--sp].w = alu(ee, er);
    return 0;
}
#define OP_ALU(operator,name) \
static uint32_t op_##name##_helper(uint32_t ee, uint32_t er) { return ee operator er; }\
static int op_##name(void) { return op_arith_core(op_##name##_helper); }
OP_ALU(+, add);
OP_ALU(-, sub);
OP_ALU(^, xor);
OP_ALU(|, or);
OP_ALU(&, and);
#define OP_SHIFT(cast,operator,name) \
static uint32_t op_##name##_helper(uint32_t ee, uint32_t er) { return (cast) ee operator (er & 0x1f); }\
static int op_##name(void) { return op_arith_core(op_##name##_helper); }
OP_SHIFT(uint32_t, <<, shl);
OP_SHIFT(uint32_t, >>, shrl);
#ifdef __GNUC__
OP_SHIFT(int32_t, >>, shra);
#else
static uint32_t op_shra_helper(uint32_t ee, uint32_t er)
{
    uint32_t sign_bit = ((uint32_t) 0x1) << 31;
    er &= 0x1f;
    return ((ee ^ sign_bit) >> er) - (sign_bit >> er);
}
static int op_shra(void)
{
    return op_arith_core(op_shra_helper);
}
#endif
#define OP_SLT(cast,name) \
static uint32_t op_##name##_helper(uint32_t ee, uint32_t er) { return -((cast) ee < (cast) er); }\
static int op_##name(void) { return op_arith_core(op_##name##_helper); }
OP_SLT(uint32_t, sltu);
OP_SLT(int32_t, slt);
static int op_getc(void)
{
    int rst = fgetc(stdin);
    if (EOF == rst)
	rst = -1;
    mem[--sp].w = rst;
    return 0;
}
static int op_putc(void)
{
    uint32_t c;
    if (pop(&c))
	return 1;
    if (EOF == fputc(c, stdout)) {
	rtn = rtn_misc;
	return 1;
    }
    return 0;
}
static int op_exit(void)
{
    uint32_t tos;
    if (pop(&tos))
	return 1;
    rtn = tos;
    return 1;
}
static int op_sentinel(void)
{
    rtn = rtn_misc;
    return 1;
}
typedef int (*opcode_type)(void);
static const opcode_type opcodes[] = {
    op_sentinel,
    op_rel, op_jmp, op_call, op_beqz, op_bnez,
    op_drop, op_drops, op_piles,
    op_set_gp, op_get_gp,
    op_pick, op_bury,
    /* 13 */
    op_add, op_sub, op_xor, op_or, op_and,
    op_slt, op_sltu,
    op_shl, op_shrl, op_shra,
    /* 23 */
    op_lb, op_lw, op_ld,
    op_sb, op_sw, op_sd,
    /* 29 */
    op_getc, op_putc, op_exit	/* 32 : end of 1byte code. */
};
/*
TOS+xxxxx = (TOS << width(xxxxx)) | xxxxx
76543210
000ccccc execute code ccccc
001AAAAA bury TOS to AAAAAth stack-cell
010AAAAA pick AAAAAth stack-cell
011siiii push literal siiii (s is sign-extneded)
100ccccc execute code (code = TOS+ccccc)
101AAAAA bury NOS to (TOS+AAAAA)th stack-cell
110AAAAA pick (TOS+AAAAA)th stack-cell
111iiiii TOS shift in
*/
static int exec_vm(uint8_t inst)
{
    int ext_mode = inst & 0x80;
    uint32_t arg = inst & 0x1f;
    if (ext_mode) {
	uint32_t tos;
	if (pop(&tos))
	    return 1;
	arg = tos << 5 | arg;
    }
    if (inst & 0x40) {
	if (inst & 0x20) {
	    if (!ext_mode)
		arg = (arg ^ 0x10) - 0x10;
	    mem[--sp].w = arg;
	    return 0;
	} else
	    return pick_core(arg);
    } else {
	if (inst & 0x20)
	    return bury_core(arg);
	else if (sizeof(opcodes) / sizeof(void *) <= arg)
	    return op_sentinel();
	else
	    return (opcodes[arg]) ();
    }
}
static void init(void)
{
    size_t i;
    size_t bin;
    /* gp = pc_next = rtn = 0; */
    sp = MEM_SIZE;
    bin = 0;
    for (i = 0; i < 4; i++) {
	int c = getchar();
	bin = bin | c << i * 8;
    }
    for (i = 0; i < bin; i++) {
	int c = getchar();
	storemem(1, i, c);
    }
}
typedef struct {
    int rtn;
    uint32_t pc_back, pc_next, gp, sp_back, sp, padding[10];
} dump_helper;
static void dump(uint32_t pc_back, uint32_t sp_back)
{
    int i;
    FILE *errf = stderr;
    dump_helper vm;
    vm.rtn = rtn;
    vm.pc_back = pc_back;
    vm.pc_next = pc_next;
    vm.gp = gp;
    vm.sp_back = sp_back;
    vm.sp = sp;
    for (i = 0; i < 10; i++)
	vm.padding[i] = 0;
    fwrite(&vm, sizeof(dump_helper), 1, errf);
    fwrite(mem, 1, MEM_SIZE * sizeof(word), errf);
}
int main(void)
{
    uint32_t pc_back, sp_back;
    uint8_t inst;
    init();
  next:
    sp_back = sp;
    pc_back = pc_next;
    if (bad_addr(1, pc_next))
	goto end;
    inst = mem[0].b[pc_next++];
    if (exec_vm(inst))
	goto end;
    goto next;
  end:
    if (rtn)
	dump(pc_back, sp_back);
    return rtn;
}
