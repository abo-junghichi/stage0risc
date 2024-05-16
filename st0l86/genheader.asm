{esi}size
{edi}table

{b 0001 0000b b b}text_addr

{0111 0100 b}file_header_size
:file_header_img
{elf header}
0111 1111b  0100 0101b 0100 1100b 0100 0110b { 0x7f 'E' 'L' 'F' }
1b 1b 1b b
b b b b
b b b b
10b b 11b b
1b b b b
b b b b {entry point}
0011 0100b b b b
b b b b
b b b b
0011 0100b b 0010 0000b b 10b b
b b b b b b
{program header}
{- text page}
1b b b b {type = load}
b b b b {offset}
text_addr {virtual address}
text_addr {physical address}
b b b b {file size}
b b b b {memory size}
101b b b b {flags}
b 0001 0000b b b {align}
{- bss page}
1b b b b {type = load}
b b b b {offset}
bss_addr {virtual address}
bss_addr {physical address}
b b b b {file size (unused)}
b b 1b b {memory size}
110b b b b {flags}
b 0001 0000b b b {align}

:loop
lb eax ecx b b
sb eax ebx b b
addi ebx b 1b
addi ecx b 1b
subi edx b 1b
{ ebx=dist ecx=src edx=bytes : clobberd eax,ebx,ecx,edx }
:memcpy
cmpi edx b b
jcc ccz 1 b -loop
ret

:loop
addi size b 1b
:count_size
call -getc
cmpi ebx b filled
jcc ccz 1 b -loop
ret

:loop
lb ebx table b b
call -putc
addi table b 1b
subi size b 1b
:output
cmpi size b b
jcc ccz 1 b -loop
ret

:main
lit table b bss_addr
mov table ebx b
label -file_header_img
mov eax ecx b
lit edx b file_header_size b b b
call -memcpy
xor size size b
call -count_size
addi size b file_header_size
sd size table b 100 0100b
sd size table b 100 1000b
lit eax b text_addr
subi eax b 101b
add eax size b
sd size table b 1 1000b
lit size b file_header_size b b b
call -output
xor ebx ebx b
jmp -exit

jmp -main
