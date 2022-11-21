	.file	"emu-align-asm.c"
	.text
	.p2align 4
	.type	exec_vm, @function
exec_vm:
.LFB26:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	pushl	%edi
	.cfi_def_cfa_offset 12
	.cfi_offset 7, -12
	pushl	%esi
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushl	%ebx
	.cfi_def_cfa_offset 20
	.cfi_offset 3, -20
	call	__x86.get_pc_thunk.bx
	addl	$_GLOBAL_OFFSET_TABLE_, %ebx
	subl	$28, %esp
	.cfi_def_cfa_offset 48
	movl	pc@GOTOFF(%ebx), %esi
	testl	$3, %esi
	jne	.L38
	cmpl	$32767, %esi
	jbe	.L70
.L38:
	movl	$1, %eax
.L1:
	addl	$28, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 20
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 16
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 12
	popl	%edi
	.cfi_restore 7
	.cfi_def_cfa_offset 8
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa_offset 4
	ret
.L70:
	.cfi_restore_state
	movl	%esi, %eax
	leal	mem@GOTOFF(%ebx), %edi
	andl	$-4, %esi
	movl	$0, 32768+mem@GOTOFF(%ebx)
	shrl	$2, %eax
	addl	%edi, %esi
	movl	(%edi,%eax,4), %ecx
	movl	stdout@GOT(%ebx), %eax
	movl	%eax, 8(%esp)
	movl	stdin@GOT(%ebx), %eax
	movl	%eax, 12(%esp)
	movzbl	%cl, %eax
	jmp	*label.0@GOTOFF(%ebx,%eax,4)
.L37:
	movl	$1, %eax
.L11:
	subl	%edi, %esi
	movl	%esi, pc@GOTOFF(%ebx)
	jmp	.L1
.L5:
#APP
# 63 "emu-align-asm.c" 1
	movzbl %ch, %eax
	sarl $16, %ecx
# 0 "" 2
#NO_APP
	addl	$4, %esi
	movl	%ecx, regfile@GOTOFF(%ebx,%eax,4)
#APP
# 65 "emu-align-asm.c" 1
	movl (%esi), %ecx
	movzbl %cl, %eax
	jmp *label.0@GOTOFF(%ebx,%eax,4)
	/*65*/
# 0 "" 2
#NO_APP
.L7:
.L3:
	movzbl	%cl, %eax
	jmp	*label.0@GOTOFF(%ebx,%eax,4)
.L36:
#APP
# 157 "emu-align-asm.c" 1
	movzbl %ch, %eax
	sarl $16, %ecx
# 0 "" 2
#NO_APP
	testl	%ecx, %ecx
	jne	.L37
	pushl	%edx
	.cfi_def_cfa_offset 52
	pushl	%edx
	.cfi_def_cfa_offset 56
	movl	16(%esp), %edx
	pushl	(%edx)
	.cfi_def_cfa_offset 60
	pushl	regfile@GOTOFF(%ebx,%eax,4)
	.cfi_def_cfa_offset 64
	call	fputc@PLT
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	movl	%eax, %edx
	addl	$1, %edx
	je	.L37
	leal	4(%esi), %esi
#APP
# 162 "emu-align-asm.c" 1
	movl (%esi), %ecx
	movzbl %cl, %eax
	jmp *label.0@GOTOFF(%ebx,%eax,4)
	/*162*/
# 0 "" 2
#NO_APP
.L35:
#APP
# 146 "emu-align-asm.c" 1
	movzbl %ch, %ebp
	sarl $16, %ecx
# 0 "" 2
#NO_APP
	testl	%ecx, %ecx
	jne	.L37
	subl	$12, %esp
	.cfi_def_cfa_offset 60
	addl	$4, %esi
	movl	24(%esp), %eax
	pushl	(%eax)
	.cfi_def_cfa_offset 64
	call	fgetc@PLT
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	movl	%eax, regfile@GOTOFF(%ebx,%ebp,4)
#APP
# 155 "emu-align-asm.c" 1
	movl (%esi), %ecx
	movzbl %cl, %eax
	jmp *label.0@GOTOFF(%ebx,%eax,4)
	/*155*/
# 0 "" 2
#NO_APP
.L34:
#APP
# 141 "emu-align-asm.c" 1
	movzbl %ch, %eax
	sarl $16, %ecx
# 0 "" 2
#NO_APP
	orl	%eax, %ecx
	setne	%al
	movzbl	%al, %eax
	jmp	.L11
.L33:
#APP
# 132 "emu-align-asm.c" 1
	movzbl %ch, %ebp
	shrl $16, %ecx
	movzbl %ch, %edx
	movzbl %cl, %eax
# 0 "" 2
#NO_APP
	addl	regfile@GOTOFF(%ebx,%edx,4), %eax
	testb	$3, %al
	jne	.L37
	cmpl	$32767, %eax
	ja	.L37
	movl	regfile@GOTOFF(%ebx,%ebp,4), %edx
	shrl	$2, %eax
	addl	$4, %esi
	movl	%edx, (%edi,%eax,4)
#APP
# 139 "emu-align-asm.c" 1
	movl (%esi), %ecx
	movzbl %cl, %eax
	jmp *label.0@GOTOFF(%ebx,%eax,4)
	/*139*/
# 0 "" 2
#NO_APP
.L32:
#APP
# 130 "emu-align-asm.c" 1
	movzbl %ch, %ebp
	shrl $16, %ecx
	movzbl %ch, %edx
	movzbl %cl, %eax
# 0 "" 2
#NO_APP
	addl	regfile@GOTOFF(%ebx,%edx,4), %eax
	movl	regfile@GOTOFF(%ebx,%ebp,4), %ebp
	cmpl	$32767, %eax
	ja	.L37
	testb	$1, %al
	jne	.L37
	movl	%eax, %edx
	andl	$3, %eax
	movzwl	%bp, %ebp
	addl	$4, %esi
	leal	0(,%eax,8), %ecx
	movl	$65535, %eax
	shrl	$2, %edx
	sall	%cl, %eax
	sall	%cl, %ebp
	notl	%eax
	andl	(%edi,%edx,4), %eax
	orl	%ebp, %eax
	movl	%eax, (%edi,%edx,4)
#APP
# 130 "emu-align-asm.c" 1
	movl (%esi), %ecx
	movzbl %cl, %eax
	jmp *label.0@GOTOFF(%ebx,%eax,4)
	/*130*/
# 0 "" 2
#NO_APP
.L31:
#APP
# 129 "emu-align-asm.c" 1
	movzbl %ch, %edx
	shrl $16, %ecx
	movzbl %ch, %ebp
	movzbl %cl, %eax
# 0 "" 2
#NO_APP
	addl	regfile@GOTOFF(%ebx,%ebp,4), %eax
	movl	regfile@GOTOFF(%ebx,%edx,4), %edx
	cmpl	$32767, %eax
	ja	.L37
	movl	%eax, %ebp
	andl	$3, %eax
	movzbl	%dl, %edx
	addl	$4, %esi
	leal	0(,%eax,8), %ecx
	movl	$255, %eax
	shrl	$2, %ebp
	sall	%cl, %eax
	sall	%cl, %edx
	notl	%eax
	andl	(%edi,%ebp,4), %eax
	orl	%edx, %eax
	movl	%eax, (%edi,%ebp,4)
#APP
# 129 "emu-align-asm.c" 1
	movl (%esi), %ecx
	movzbl %cl, %eax
	jmp *label.0@GOTOFF(%ebx,%eax,4)
	/*129*/
# 0 "" 2
#NO_APP
.L30:
#APP
# 120 "emu-align-asm.c" 1
	movzbl %ch, %ebp
	shrl $16, %ecx
	movzbl %ch, %edx
	movzbl %cl, %eax
# 0 "" 2
#NO_APP
	addl	regfile@GOTOFF(%ebx,%edx,4), %eax
	testb	$3, %al
	jne	.L37
	cmpl	$32767, %eax
	ja	.L37
	shrl	$2, %eax
	addl	$4, %esi
	movl	(%edi,%eax,4), %eax
	movl	%eax, regfile@GOTOFF(%ebx,%ebp,4)
#APP
# 127 "emu-align-asm.c" 1
	movl (%esi), %ecx
	movzbl %cl, %eax
	jmp *label.0@GOTOFF(%ebx,%eax,4)
	/*127*/
# 0 "" 2
#NO_APP
.L29:
#APP
# 118 "emu-align-asm.c" 1
	movzbl %ch, %eax
	shrl $16, %ecx
	movzbl %ch, %edx
	movzbl %cl, %ecx
# 0 "" 2
#NO_APP
	addl	regfile@GOTOFF(%ebx,%edx,4), %ecx
	cmpl	$32767, %ecx
	ja	.L37
	testb	$1, %cl
	jne	.L37
	movl	%ecx, %edx
	andl	$3, %ecx
	addl	$4, %esi
	shrl	$2, %edx
	sall	$3, %ecx
	movl	(%edi,%edx,4), %edx
	shrl	%cl, %edx
	movswl	%dx, %edx
	movl	%edx, regfile@GOTOFF(%ebx,%eax,4)
#APP
# 118 "emu-align-asm.c" 1
	movl (%esi), %ecx
	movzbl %cl, %eax
	jmp *label.0@GOTOFF(%ebx,%eax,4)
	/*118*/
# 0 "" 2
#NO_APP
.L28:
#APP
# 117 "emu-align-asm.c" 1
	movzbl %ch, %edx
	shrl $16, %ecx
	movzbl %ch, %eax
	movzbl %cl, %ecx
# 0 "" 2
#NO_APP
	addl	regfile@GOTOFF(%ebx,%eax,4), %ecx
	cmpl	$32767, %ecx
	ja	.L37
	movl	%ecx, %eax
	andl	$3, %ecx
	addl	$4, %esi
	shrl	$2, %eax
	sall	$3, %ecx
	movl	(%edi,%eax,4), %eax
	shrl	%cl, %eax
	movsbl	%al, %eax
	movl	%eax, regfile@GOTOFF(%ebx,%edx,4)
#APP
# 117 "emu-align-asm.c" 1
	movl (%esi), %ecx
	movzbl %cl, %eax
	jmp *label.0@GOTOFF(%ebx,%eax,4)
	/*117*/
# 0 "" 2
#NO_APP
.L27:
#APP
# 115 "emu-align-asm.c" 1
	movzbl %ch, %eax
	shrl $16, %ecx
	movzbl %ch, %ebp
	movzbl %cl, %edx
# 0 "" 2
#NO_APP
	movl	regfile@GOTOFF(%ebx,%ebp,4), %ecx
	movl	regfile@GOTOFF(%ebx,%eax,4), %eax
	addl	$4, %esi
	sarl	%cl, %eax
	movl	%eax, regfile@GOTOFF(%ebx,%edx,4)
#APP
# 115 "emu-align-asm.c" 1
	movl (%esi), %ecx
	movzbl %cl, %eax
	jmp *label.0@GOTOFF(%ebx,%eax,4)
	/*115*/
# 0 "" 2
#NO_APP
.L26:
#APP
# 112 "emu-align-asm.c" 1
	movzbl %ch, %eax
	shrl $16, %ecx
	movzbl %ch, %ebp
	movzbl %cl, %edx
# 0 "" 2
#NO_APP
	movl	regfile@GOTOFF(%ebx,%ebp,4), %ecx
	movl	regfile@GOTOFF(%ebx,%eax,4), %eax
	addl	$4, %esi
	shrl	%cl, %eax
	movl	%eax, regfile@GOTOFF(%ebx,%edx,4)
#APP
# 112 "emu-align-asm.c" 1
	movl (%esi), %ecx
	movzbl %cl, %eax
	jmp *label.0@GOTOFF(%ebx,%eax,4)
	/*112*/
# 0 "" 2
#NO_APP
.L25:
#APP
# 111 "emu-align-asm.c" 1
	movzbl %ch, %eax
	shrl $16, %ecx
	movzbl %ch, %ebp
	movzbl %cl, %edx
# 0 "" 2
#NO_APP
	movl	regfile@GOTOFF(%ebx,%ebp,4), %ecx
	movl	regfile@GOTOFF(%ebx,%eax,4), %eax
	addl	$4, %esi
	sall	%cl, %eax
	movl	%eax, regfile@GOTOFF(%ebx,%edx,4)
#APP
# 111 "emu-align-asm.c" 1
	movl (%esi), %ecx
	movzbl %cl, %eax
	jmp *label.0@GOTOFF(%ebx,%eax,4)
	/*111*/
# 0 "" 2
#NO_APP
.L24:
#APP
# 108 "emu-align-asm.c" 1
	movzbl %ch, %ebp
	shrl $16, %ecx
	movzbl %ch, %edx
	movzbl %cl, %eax
# 0 "" 2
#NO_APP
	movl	regfile@GOTOFF(%ebx,%edx,4), %edx
	cmpl	%edx, regfile@GOTOFF(%ebx,%ebp,4)
	sbbl	%edx, %edx
	addl	$4, %esi
	movl	%edx, regfile@GOTOFF(%ebx,%eax,4)
#APP
# 108 "emu-align-asm.c" 1
	movl (%esi), %ecx
	movzbl %cl, %eax
	jmp *label.0@GOTOFF(%ebx,%eax,4)
	/*108*/
# 0 "" 2
#NO_APP
.L23:
#APP
# 107 "emu-align-asm.c" 1
	movzbl %ch, %ebp
	shrl $16, %ecx
	movzbl %ch, %edx
	movzbl %cl, %eax
# 0 "" 2
#NO_APP
	movl	regfile@GOTOFF(%ebx,%edx,4), %edx
	cmpl	%edx, regfile@GOTOFF(%ebx,%ebp,4)
	setl	%dl
	addl	$4, %esi
	movzbl	%dl, %edx
	negl	%edx
	movl	%edx, regfile@GOTOFF(%ebx,%eax,4)
#APP
# 107 "emu-align-asm.c" 1
	movl (%esi), %ecx
	movzbl %cl, %eax
	jmp *label.0@GOTOFF(%ebx,%eax,4)
	/*107*/
# 0 "" 2
#NO_APP
.L22:
#APP
# 105 "emu-align-asm.c" 1
	movzbl %ch, %eax
	shrl $16, %ecx
	movzbl %ch, %ebp
	movzbl %cl, %edx
# 0 "" 2
#NO_APP
	movl	regfile@GOTOFF(%ebx,%eax,4), %eax
	andl	regfile@GOTOFF(%ebx,%ebp,4), %eax
	addl	$4, %esi
	movl	%eax, regfile@GOTOFF(%ebx,%edx,4)
#APP
# 105 "emu-align-asm.c" 1
	movl (%esi), %ecx
	movzbl %cl, %eax
	jmp *label.0@GOTOFF(%ebx,%eax,4)
	/*105*/
# 0 "" 2
#NO_APP
.L20:
#APP
# 103 "emu-align-asm.c" 1
	movzbl %ch, %eax
	shrl $16, %ecx
	movzbl %ch, %ebp
	movzbl %cl, %edx
# 0 "" 2
#NO_APP
	movl	regfile@GOTOFF(%ebx,%eax,4), %eax
	xorl	regfile@GOTOFF(%ebx,%ebp,4), %eax
	addl	$4, %esi
	movl	%eax, regfile@GOTOFF(%ebx,%edx,4)
#APP
# 103 "emu-align-asm.c" 1
	movl (%esi), %ecx
	movzbl %cl, %eax
	jmp *label.0@GOTOFF(%ebx,%eax,4)
	/*103*/
# 0 "" 2
#NO_APP
.L19:
#APP
# 102 "emu-align-asm.c" 1
	movzbl %ch, %eax
	shrl $16, %ecx
	movzbl %ch, %ebp
	movzbl %cl, %edx
# 0 "" 2
#NO_APP
	movl	regfile@GOTOFF(%ebx,%eax,4), %eax
	subl	regfile@GOTOFF(%ebx,%ebp,4), %eax
	addl	$4, %esi
	movl	%eax, regfile@GOTOFF(%ebx,%edx,4)
#APP
# 102 "emu-align-asm.c" 1
	movl (%esi), %ecx
	movzbl %cl, %eax
	jmp *label.0@GOTOFF(%ebx,%eax,4)
	/*102*/
# 0 "" 2
#NO_APP
.L18:
#APP
# 101 "emu-align-asm.c" 1
	movzbl %ch, %ebp
	shrl $16, %ecx
	movzbl %ch, %eax
	movzbl %cl, %edx
# 0 "" 2
#NO_APP
	movl	regfile@GOTOFF(%ebx,%eax,4), %eax
	addl	regfile@GOTOFF(%ebx,%ebp,4), %eax
	addl	$4, %esi
	movl	%eax, regfile@GOTOFF(%ebx,%edx,4)
#APP
# 101 "emu-align-asm.c" 1
	movl (%esi), %ecx
	movzbl %cl, %eax
	jmp *label.0@GOTOFF(%ebx,%eax,4)
	/*101*/
# 0 "" 2
#NO_APP
.L17:
#APP
# 99 "emu-align-asm.c" 1
	movzbl %ch, %eax
# 0 "" 2
#NO_APP
	cmpl	$0, regfile@GOTOFF(%ebx,%eax,4)
	je	.L15
.L14:
	movl	%esi, %eax
	subl	%edi, %eax
#APP
# 90 "emu-align-asm.c" 1
	sarl $16, %ecx
# 0 "" 2
#NO_APP
	addl	%ecx, %eax
	testb	$3, %al
	jne	.L37
	cmpl	$32767, %eax
	ja	.L37
	leal	(%edi,%eax), %esi
#APP
# 95 "emu-align-asm.c" 1
	movl (%esi), %ecx
	movzbl %cl, %eax
	jmp *label.0@GOTOFF(%ebx,%eax,4)
	/*95*/
# 0 "" 2
#NO_APP
.L16:
#APP
# 98 "emu-align-asm.c" 1
	movzbl %ch, %eax
# 0 "" 2
#NO_APP
	cmpl	$0, regfile@GOTOFF(%ebx,%eax,4)
	je	.L14
.L15:
	addl	$4, %esi
#APP
# 97 "emu-align-asm.c" 1
	movl (%esi), %ecx
	movzbl %cl, %eax
	jmp *label.0@GOTOFF(%ebx,%eax,4)
	/*97*/
# 0 "" 2
#NO_APP
.L12:
#APP
# 81 "emu-align-asm.c" 1
	movzbl %ch, %edx
	shrl $16, %ecx
	movzbl %ch, %eax
	movzbl %cl, %ecx
# 0 "" 2
#NO_APP
	movl	regfile@GOTOFF(%ebx,%eax,4), %eax
	addl	regfile@GOTOFF(%ebx,%edx,4), %eax
	testb	$3, %al
	jne	.L37
	cmpl	$32767, %eax
	ja	.L37
	leal	4(%esi), %edx
	leal	(%edi,%eax), %esi
	subl	%edi, %edx
	movl	%edx, regfile@GOTOFF(%ebx,%ecx,4)
#APP
# 87 "emu-align-asm.c" 1
	movl (%esi), %ecx
	movzbl %cl, %eax
	jmp *label.0@GOTOFF(%ebx,%eax,4)
	/*87*/
# 0 "" 2
#NO_APP
.L8:
	movl	%esi, %edx
	movl	%esi, %eax
	subl	%edi, %edx
#APP
# 73 "emu-align-asm.c" 1
	movzbl %ch, %ebp
	sarl $16, %ecx
# 0 "" 2
#NO_APP
	addl	%ecx, %edx
	testb	$3, %dl
	jne	.L37
	cmpl	$32767, %edx
	ja	.L37
	addl	$4, %eax
	leal	(%edi,%edx), %esi
	subl	%edi, %eax
	movl	%eax, regfile@GOTOFF(%ebx,%ebp,4)
#APP
# 79 "emu-align-asm.c" 1
	movl (%esi), %ecx
	movzbl %cl, %eax
	jmp *label.0@GOTOFF(%ebx,%eax,4)
	/*79*/
# 0 "" 2
#NO_APP
.L21:
#APP
# 104 "emu-align-asm.c" 1
	movzbl %ch, %eax
	shrl $16, %ecx
	movzbl %ch, %ebp
	movzbl %cl, %edx
# 0 "" 2
#NO_APP
	movl	regfile@GOTOFF(%ebx,%eax,4), %eax
	orl	regfile@GOTOFF(%ebx,%ebp,4), %eax
	addl	$4, %esi
	movl	%eax, regfile@GOTOFF(%ebx,%edx,4)
#APP
# 104 "emu-align-asm.c" 1
	movl (%esi), %ecx
	movzbl %cl, %eax
	jmp *label.0@GOTOFF(%ebx,%eax,4)
	/*104*/
# 0 "" 2
#NO_APP
.L6:
	movl	%esi, %ebp
	addl	$4, %esi
	subl	%edi, %ebp
#APP
# 67 "emu-align-asm.c" 1
	movzbl %ch, %edx
	sarl $16, %ecx
# 0 "" 2
#NO_APP
	addl	%ecx, %ebp
	movl	%ebp, regfile@GOTOFF(%ebx,%edx,4)
#APP
# 69 "emu-align-asm.c" 1
	movl (%esi), %ecx
	movzbl %cl, %eax
	jmp *label.0@GOTOFF(%ebx,%eax,4)
	/*69*/
# 0 "" 2
#NO_APP
	.cfi_endproc
.LFE26:
	.size	exec_vm, .-exec_vm
	.p2align 4
	.type	dump, @function
dump:
.LFB28:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	$512, %ecx
	pushl	%edi
	.cfi_def_cfa_offset 12
	.cfi_offset 7, -12
	pushl	%esi
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushl	%ebx
	.cfi_def_cfa_offset 20
	.cfi_offset 3, -20
	call	__x86.get_pc_thunk.bx
	addl	$_GLOBAL_OFFSET_TABLE_, %ebx
	subl	$2076, %esp
	.cfi_def_cfa_offset 2096
	leal	12(%esp), %edx
	movl	%edx, %edi
	movl	%gs:20, %eax
	movl	%eax, 2060(%esp)
	movl	stderr@GOT(%ebx), %eax
	leal	regfile@GOTOFF(%ebx), %esi
	movl	(%eax), %ebp
	xorl	%eax, %eax
	rep stosl
	leal	524(%esp), %edi
	movl	$256, %ecx
	movl	pc@GOTOFF(%ebx), %eax
	rep movsl
	movl	%eax, 20(%esp)
	pushl	%ebp
	.cfi_def_cfa_offset 2100
	pushl	$512
	.cfi_def_cfa_offset 2104
	pushl	$4
	.cfi_def_cfa_offset 2108
	pushl	%edx
	.cfi_def_cfa_offset 2112
	call	fwrite@PLT
	leal	mem@GOTOFF(%ebx), %eax
	pushl	%ebp
	.cfi_def_cfa_offset 2116
	pushl	$8192
	.cfi_def_cfa_offset 2120
	pushl	$4
	.cfi_def_cfa_offset 2124
	pushl	%eax
	.cfi_def_cfa_offset 2128
	call	fwrite@PLT
	addl	$32, %esp
	.cfi_def_cfa_offset 2096
	movl	2060(%esp), %eax
	subl	%gs:20, %eax
	jne	.L74
	addl	$2076, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 20
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 16
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 12
	popl	%edi
	.cfi_restore 7
	.cfi_def_cfa_offset 8
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa_offset 4
	ret
.L74:
	.cfi_restore_state
	call	__stack_chk_fail_local
	.cfi_endproc
.LFE28:
	.size	dump, .-dump
	.section	.text.startup,"ax",@progbits
	.p2align 4
	.globl	main
	.type	main, @function
main:
.LFB29:
	.cfi_startproc
	call	__x86.get_pc_thunk.ax
	addl	$_GLOBAL_OFFSET_TABLE_, %eax
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	xorl	%edx, %edx
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	.cfi_offset 7, -12
	.cfi_offset 6, -16
	.cfi_offset 3, -20
	leal	mem@GOTOFF(%eax), %edi
	andl	$-16, %esp
	subl	$16, %esp
	movl	%eax, 12(%esp)
	.p2align 4,,10
	.p2align 3
.L76:
	movl	%edx, %ecx
	movl	12(%esp), %ebx
	movl	%edx, %esi
	movl	$255, %eax
	andl	$3, %ecx
	shrl	$2, %esi
	movzbl	rom@GOTOFF(%edx,%ebx), %ebx
	sall	$3, %ecx
	addl	$1, %edx
	sall	%cl, %eax
	notl	%eax
	sall	%cl, %ebx
	andl	(%edi,%esi,4), %eax
	orl	%ebx, %eax
	movl	%eax, (%edi,%esi,4)
	cmpl	$80, %edx
	jne	.L76
	call	exec_vm
	testl	%eax, %eax
	jne	.L83
.L77:
	leal	-12(%ebp), %esp
	xorl	%eax, %eax
	popl	%ebx
	.cfi_remember_state
	.cfi_restore 3
	popl	%esi
	.cfi_restore 6
	popl	%edi
	.cfi_restore 7
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
.L83:
	.cfi_restore_state
	call	dump
	jmp	.L77
	.cfi_endproc
.LFE29:
	.size	main, .-main
	.section	.data.rel.local,"aw"
	.align 32
	.type	label.0, @object
	.size	label.0, 1024
label.0:
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L5
	.long	.L6
	.long	.L8
	.long	.L12
	.long	.L16
	.long	.L17
	.long	.L18
	.long	.L19
	.long	.L20
	.long	.L21
	.long	.L22
	.long	.L23
	.long	.L24
	.long	.L25
	.long	.L26
	.long	.L27
	.long	.L28
	.long	.L29
	.long	.L30
	.long	.L31
	.long	.L32
	.long	.L33
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L34
	.long	.L35
	.long	.L36
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.long	.L37
	.local	mem
	.comm	mem,32772,32
	.local	regfile
	.comm	regfile,1024,32
	.local	pc
	.comm	pc,4,4
	.section	.rodata
	.align 32
	.type	rom, @object
	.size	rom, 80
rom:
	.string	"\200\001\001"
	.string	"\200\375\b"
	.string	"\200\376\020"
	.string	"\241\n"
	.string	""
	.string	"\241\013"
	.string	""
	.string	"\241\f"
	.string	""
	.string	"\241\r"
	.string	""
	.string	"\215\013\013\375\211\n\n\013\215\r\r\375\211\f\f\r\215\f\f\376\211\n\n\f\201\r\034"
	.string	"\202\377\024"
	.string	"\241\f"
	.string	""
	.string	"\223\f"
	.ascii	"\r\206\r\r\001\207\n\n\001\205\n\360\377"
	.section	.text.__x86.get_pc_thunk.ax,"axG",@progbits,__x86.get_pc_thunk.ax,comdat
	.globl	__x86.get_pc_thunk.ax
	.hidden	__x86.get_pc_thunk.ax
	.type	__x86.get_pc_thunk.ax, @function
__x86.get_pc_thunk.ax:
.LFB30:
	.cfi_startproc
	movl	(%esp), %eax
	ret
	.cfi_endproc
.LFE30:
	.section	.text.__x86.get_pc_thunk.bx,"axG",@progbits,__x86.get_pc_thunk.bx,comdat
	.globl	__x86.get_pc_thunk.bx
	.hidden	__x86.get_pc_thunk.bx
	.type	__x86.get_pc_thunk.bx, @function
__x86.get_pc_thunk.bx:
.LFB31:
	.cfi_startproc
	movl	(%esp), %ebx
	ret
	.cfi_endproc
.LFE31:
	.hidden	__stack_chk_fail_local
	.ident	"GCC: (Gentoo 11.3.0 p4) 11.3.0"
	.section	.note.GNU-stack,"",@progbits
