{esi}count
{edi}sp
{ecx}tc

{0111 1011b}brac
{0111 1101b}cket

:pop_num_core
subi sp b 1b
lb ebx sp b b
call -putc
:pop_num
lit eax b bss_addr
cmp sp eax b
jcc ccz 1 b -pop_num_core
ret

:push_num_core
mov tc eax b
andi eax b 1b
addi eax b 0011 0000b {charzero}
sb eax sp b b
addi sp b 1b
shrli tc b 1b
:push_num
cmpi tc b b
jcc ccz 1 b -push_num_core
jmp -pop_num

:print_count
mov count tc b
lit sp b bss_addr
jmp -push_num

:for_eof
xor ebx ebx b
jmp -exit
:geteof
call -getc
cmpi ebx b filled
jcc ccz 0 b -for_eof
call -putc
ret

:skip_comment
call -geteof
cmpi ebx b cket
jcc ccz 1 b -skip_comment
:core
call -geteof
cmpi ebx b brac
jcc ccz 0 b -skip_comment
cmpi ebx b 0011 1010b {colon}
jcc ccz 1 b -core
lit ebx b brac b b b
call -putc
call -print_count
addi count b 1b
lit ebx b 0100 0000b b b b {atmark}
call -putc
lit ebx b cket b b b
call -putc
lit ebx b 0010 1101b b b b {charminus}
call -putc
jmp -core

:main
xor count count b
jmp -core

jmp -main
