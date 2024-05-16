{esi}imm
{edi}pos
{ebx}peek
{edx}tp

:error
lit ebx b 1b b b b
jmp -exit

:end_of_file
cmpi imm b b
jcc ccz 1 b -error
xor ebx ebx b
jmp -exit

:shiftin
shli imm b 1b
subi peek b 110000b { '0' }
or peek imm b
ret

:write_byte
addi pos b 1b
mov imm peek b
call -putc
xor imm imm b
ret

:def_label
sd pos ebp b b
addi ebp b 100b
ret

:ref_label
shli imm b 10b
lit eax b bss_addr
add eax imm b
ld peek imm b b
addi pos b 100b
sub pos peek b
call -putc
shrai peek b 1000b
call -putc
shrai peek b 1000b
call -putc
shrai peek b 1000b
call -putc
xor imm imm b
ret

:whitespace
ret

:table
00100000b b -whitespace { ' ' }
00001010b b -whitespace { '\n' }
00110000b b -shiftin { '0' }
00110001b b -shiftin
01100010b b -write_byte { 'b' }
00111010b b -def_label { ':' }
01000000b b -ref_label { '@' }
filled filled -end_of_file { EOF }
b b -error { end of table }{ means '\0' is forced to use this }

:loop
addi tp b 110b
:search
lw eax tp b b
sxw eax eax b
cmpi eax b b
jcc ccz 0 b -error
cmp ebx eax b
jcc ccz 1 b -loop
ld eax tp b 10b
add tp eax b
addi eax b 110b
callr eax b
:read
call -getc
label -table
mov eax tp b
jmp -search

:main
xor imm imm b
xor pos pos b
lit ebp b bss_addr
jmp -read

jmp -main
