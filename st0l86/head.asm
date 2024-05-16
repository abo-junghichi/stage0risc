{11111111b}filled

{000}eax
{001}ecx
{010}edx
{011}ebx
{100}esp
{101}ebp
{110}esi
{111}edi

{11101001b}jmp
{11101000b}call
{11000011b}ret
{11001101b 10000000b}int80
{register indirect jump/call} {11111111b 11}callr
{op Rlink b}
{callr 100}jmpr
{callr 010}callr

{condition code}
{unsigned little} {001}cclu
{signed little} {110}ccl
{zero} {010}ccz
{jcc cc is=0/not=1 b 4byte-rel} {00001111b 1000}jcc

{op Rsrc Racc b}
{00000001b 11}add
{00101001b 11}sub
{00111001b 11}cmp
{00100001b 11}and
{00001001b 11}or
{00110001b 11}xor
{00001111b 10110110b 11}zxb
{00001111b 10110111b 11}zxw
{00001111b 10111110b 11}sxb
{00001111b 10111111b 11}sxw
{10001001b 11}mov

{op Racc b}
{11110111b 11}not
{not 011}neg
{not 010}not

{op Racc b singed_1byte}
{10000011b 11}calc
{calc 000}addi
{calc 101}subi
{calc 111}cmpi
{calc 100}andi
{calc 001}ori
{calc 110}xori
{11000001b 11100}shli
{11000001b 11101}shrli
{11000001b 11111}shrai

{
 Do not use esp at Rbase!
}
{load Rdist Rbase b disp8}
{
 Upper bytes of Rdist is not changed!
 Use z/sxb/w for sign extention.
}
{10001010b 01}lb
{01100110b 10001011b 01}lw
{10001011b 01}ld
{store Rsrc Rbase b disp8}
{10001000b 01}sb
{01100110b 10001001b 01}sw
{10001001b 01}sd
{push reg b} {01010}push
{pop reg b} {01011}pop

{lit reg b 4byte} {10111}lit
{label -label : set absolute address of label to eax}
:get_pc
{movl (esp), eax} 10001011b 00 eax esp b 00100100b
addi eax b 101b
ret
{
 call -get_pc
 00000101b
}label

{0b 0b 1b 0b}bss_addr

{ exit with ebx }
:exit
lit eax b 1b b b b
int80

{ put char from ebx : clobbered eax,ecx,edx }
:putc
push ebx b
lit eax b 100b b b b
lit edx b 1b b b b
mov edx ebx b
mov esp ecx b
int80
pop ebx b
ret

:getc_eof
not ebx b
ret
{ get unsigned char or EOF to ebx  : clobbered eax,ebx,ecx,edx }
:getc
lit eax b 11b b b b
lit edx b 1b b b b
xor ebx ebx b
push ebx b
mov esp ecx b
int80
pop ebx b
cmpi eax b 1b
jcc ccz 1 b -getc_eof
ret

{
 lit ebx b 10b b b b
 jmp -exit
}break

:dump
lb ebx ebp b b
addi ebp b 1b
call -putc
jmp -dump
