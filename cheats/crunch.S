#define lit 80
#define v1 01
#define v16 10
lit v1 01 00
lit v16 10 00

#define max 0A
#define shll 8D
lit max FF 00
shll max max v16
#define count 0C
lit count 00 00
#define rel 81
#define addr 0B
rel addr +data
#define sd 95
sd v1 00 addr

:crunch
#define ld 92
#define val 0D
#define add 86
#define sltu 8C
#define flag 0F
#define bnez 85
ld val 00 addr
add count count val
sltu count flag max
bnez flag -crunch

A0 00 00 00 # system

:data
01 00 00 00
