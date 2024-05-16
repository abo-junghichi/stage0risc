:put
call -putc
:main
call -getc
cmpi ebx b filled
jcc ccz 1 b -put
xor ebx ebx b
jmp -exit

{:entry}
jmp -main
