{
since middle brackets are used as comment begin/end,
read [] to middle brackets.
}
{
(bss_addr=ebp)
error_delim
mp
wp
peek
entry_interp_word
(dp)[cont]key...[cont]key[cont]key(mp)[new cont'delim'(wp)]word(sp)]
}
{b}error_delim
{  1 00b}mp
{ 10 00b}wp
{ 11 00b}peek
{100 00b}entry_interp_word
{101 00b}dp

{01111011b}brac
{01111101b}cket

:error
lit ebx b 1b b b b
jmp -exit

:table
00100000b b { ' ' }
00001010b b { '\n' }
brac b { [ }
cket b { ] }
filled filled { EOF }
b b { end of table }

:next_peek
sb ebx esi b b
addi esi b 1b
{
 assume
 sp->esi
 peek->ebx
}
:read_word
call -getc
label -table
:check_delim
lw ecx eax b b
sxw ecx ecx b
cmpi ecx b b
jcc ccz 0 b -next_peek
addi eax b 10b
cmp ebx ecx b
jcc ccz 1 b -check_delim
ld eax ebp b error_delim
cmp ebx eax b
jcc ccz 0 b -error
sd ebx ebp b peek
lit eax b cket b b b
sb eax esi b b
ret

:search_key
subi eax b 1b
lb ecx eax b b
zxb ecx ecx b
cmpi ecx b brac
jcc ccz 1 b -search_key
ret

:search_end
ld edi ebp b wp
mov edi eax b
addi eax b 1b
ret
:search_next
call -search_key
:check_end
cmp eax ebx b
jcc ccz 0 b -search_end
:cmpstr
mov esi edi b
:loop
subi eax b 1b
subi edi b 1b
lb ecx eax b b
zxb ecx ecx b
lb edx edi b b
zxb edx edx b
cmp ecx edx b
jcc ccz 1 b -search_next
cmpi ecx b cket
jcc ccz 1 b -loop
call -search_key
addi eax b 1b
ld edi ebp b wp
ret
{
 assume
 wp->edi
 sp->esi
}
:search_macro
sd edi ebp b wp
lit eax b cket b b b
sb eax edi b b
mov edi esi b
addi esi b 1b
call -read_word
ld eax ebp b mp
mov ebp ebx b
addi ebx b dp
jmp -check_end

:defmacro_comment
ld edi ebp b mp
:defmacro_end
sd edi ebp b wp
ld eax ebp b entry_interp_word
jmpr eax b
:defmacro_name
lit eax b cket b b b
sd eax ebp b error_delim
sb eax edi b b
addi edi b 1b
mov edi esi b
call -read_word
cmp edi esi b
jcc ccz 0 b -defmacro_comment
sd esi ebp b mp
mov esi edi b
jmp -defmacro_end
:loop
sb ecx edi b b
addi eax b 1b
addi edi b 1b
:expand
lb ecx eax b b
zxb ecx ecx b
cmpi ecx b cket
jcc ccz 1 b -loop
ld ebx ebp b peek
cmpi ebx b cket
jcc ccz 0 b -defmacro_name
cmpi ebx b filled {EOF}
jcc ccz 0 b -error
sb ebx edi b b
:search
addi edi b 1b
call -search_macro
jmp -expand
{
 assume none
}
:defmacro
ld edi ebp b wp
lit eax b brac b b b
sd eax ebp b error_delim
sb eax edi b b
jmp -search

:done
xor ebx ebx b
jmp -exit
:output
call -putc
addi esi b 1b
:loop
lb ebx esi b b
zxb ebx ebx b
cmpi ebx b cket
jcc ccz 1 b -output
:interp_word
ld edi ebp b peek
cmpi edi b brac
jcc ccz 0 b -defmacro
cmpi edi b filled {EOF}
jcc ccz 0 b -done
mov edi ebx b
call -putc
:interp_word_main
ld edi ebp b wp
call -search_macro
mov eax esi b
jmp -loop

:main
lit ebp b bss_addr
label -interp_word
sd eax ebp b entry_interp_word
mov ebp eax b
addi eax b dp
sd eax ebp b mp
sd eax ebp b wp
lit eax b cket b b b
sd eax ebp b error_delim
jmp -interp_word_main

jmp -main
