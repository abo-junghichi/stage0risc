/*
bootloader in the rom.
*/
#define lit 80
#define getc(reg) a1 reg 00 00
#define shl 8d
#define or 89
#define rel 81

#define v1 01
lit v1 01 00
#define v8 fd
lit v8 08 00
#define v16 fe
lit v16 10 00

// read 4 byte header
getc(0a)
getc(0b)
getc(0c)
getc(0d)
shl 0b 0b v8
or 0a 0a 0b
shl 0d 0d v8
or 0c 0c 0d
shl 0c 0c v16
or 0a 0a 0c
#define len 0a
#define dp 0d
rel dp +data
#define jal 82
jal ff +branch
:loop
#define char 0c
getc(0c)
93 /* sb */ char 00 dp
86 /* add */ dp dp v1
87 /* sub */ len len v1
:branch
85 /* bnez */ len -loop
:data
