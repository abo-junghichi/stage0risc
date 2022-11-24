#define lit 80

#define v1 01
lit v1 01 00
#define v8 fd
lit v8 08 00

#define seed 02
#define tap 03
#define flag 04
#define count 05

lit seed 01 00
lit count 00 00
81 /* rel */ tap +tap_data
92 /* ld */ tap 00 tap

:lfsr
#define and 8a
and seed flag v1
#define shrl 8e
shrl seed seed v1
#define beqz 84
beqz flag +tap_end
#define xor 88
xor seed seed tap
:tap_end
86 /* add */ count count v1
xor seed flag v1
85 /* bnez */ flag -lfsr

#define mask 03
#define char 06
lit mask ff 00
:print_core
beqz count +end
and count char mask
a2 char 00 00 /* putc */
shrl count count v8
82 /* jal */ ff -print_core
:end
a0 00 00 00 /* system */
:tap_data
00 00 42 00
