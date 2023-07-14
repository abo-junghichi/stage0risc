#include "opcode.S"

#define zero 00
#define tmp 01
#define dp 02
#define ret jalr zero tmp
#define mv or zero
jal tmp +set_dp
