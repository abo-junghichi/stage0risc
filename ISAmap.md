# Instruction length
Although there are no plans to extend the ISA, and,
rebuilding ISA is preferred for minimizing proccessor implementation,
Instruction length is encoded
in some MSBs at the first byte of each instruction.

	00                  : invalid instruction
	01 - 3f (00XX-XXXX) :   1 byte
	40 - 7f (01XX-XXXX) :   2 bytes
	80 - bf (10XX-XXXX) :   4 bytes - used at current project.
	c0 - df (110X-XXXX) :   8 bytes
	e0 - ef (1110-XXXX) :  16 bytes
	f0 - f7 (1111-0XXX) :  32 bytes
	f8 - fb (1111-10XX) :  64 bytes
	fc - fd (1111-110X) : 128 bytes
	fe      (1111-1110) : 256 bytes
	ff      (1111-1111) : reserved for 512 bytes or longer

# Encoding for Registers
There is a direct and consistent relationship
between the bytes(8bits) and the 256 general purpose registers.

# Instruction listing
## Set value to a register

	    opcode destination-reg signed-2byte
	lit 80     Rd              LO HI        Rd = HILO
	rel 81     Rd              LO HI        Rd = PC + HILO
	jal 82     Rlink           LO HI        Rlink = PC+4 ; PC = PC + HILO

## Conditional branch

	     opcode source-reg signed-2byte
	beqz 84     Rs         LO HI        if(0==Rs) PC = PC + HILO
	bnez 85     Rs         LO HI        if(0!=Rs) PC = PC + HILO

## Three register operands

	     opcode source destination acter
	jalr 83     Rs     Rlink       Rt    Rlink = PC+4 ; PC = Rs + Rt
	add  86     Rs     Rd          Rt    Rd = Rs + Rt
	sub  87     Rs     Rd          Rt    Rd = Rs - Rt
	xor  88     Rs     Rd          Rt    Rd = Rs ^ Rt
	or   89     Rs     Rd          Rt    Rd = Rs | Rt
	and  8a     Rs     Rd          Rt    Rd = Rs & Rt
	slt  8b     Rs     Rd          Rt    if ((signed)Rs < (signed)Rt) Rd = ~0 ; else Rd = 0
	sltu 8c     Rs     Rd          Rt    if ((unsigned)Rs < (unsigned)Rt) Rd = ~0 ; else Rd = 0
	shl  8d     Rs     Rd          Rt    Rd = Rs << Rt
	shrl 8e     Rs     Rd          Rt    Rd = Rs >> Rt [fill with zeros]
	shra 8f     Rs     Rd          Rt    Rd = Rs >> Rt [fill with MSB]

## Load from memory

	   opcode destination unsigned-offset base
	lb 90     Rd          LO              Rb   Rd = MEM[Rb + LO] [signed 8bits]
	lw 91     Rd          LO              Rb   Rd = MEM[Rb + LO] [signed 16bits]
	ld 92     Rd          LO              Rb   Rd = MEM[Rb + LO] [(signed) 32bits]

## Store to memory

	   opcode source unsigned-offset base
	sb 93     Rs     LO              Rb   MEM[Rb + LO] = Rs [8bits]
	sw 94     Rs     LO              Rb   MEM[Rb + LO] = Rs [16bits]
	sd 95     Rs     LO              Rb   MEM[Rb + LO] = Rs [32bits]

## IO

	       opcode register padding
	system        (none)   00 00 00 halt the system.
	getc   a1     Rd       00 00    read 1byte from input. ~0 for EOF.
	putc   a2     Rs       00 00    write 1byte to output.
