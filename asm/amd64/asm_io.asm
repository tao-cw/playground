%macro prologue 0
		push	rbp
		mov		rbp,rsp	
		push	rbx
		push	r12
		push	r13
		push	r14
		push	r15
%endmacro
%macro epilogue 0
		pop		r15
		pop		r14
		pop		r13
		pop		r12
		pop		rbx
		leave
		ret
%endmacro
section .rodata
	int_format	db	"%i",0
    string_format db "%s",0
section .text
	global	print_string2, print_nl2, print_int, read_int
	global print_string, print_nl
	extern printf, scanf, putchar
	print_string2:
		prologue
		; argument is already in rdi
		mov		rcx,dword -1
		xor		al,al
		cld
		repnz	scasb
		mov		rdx,dword -2
		sub		rdx,rcx	 
		mov		rsi,rdi
		push	0x1
		pop		rax
		mov		rdi,rax
		syscall
		epilogue

	print_nl2:
		prologue
		; print 0xa is only one byte
		push	0xA
		mov		rsi,rsp
		push	0x1
		pop		rdx
		mov		rdi,rdx
		mov		rax,rdx
		syscall
		pop		rcx
		epilogue
	print_string:
		prologue
		mov		rsi,rdi
		mov		rdi,dword string_format
		xor		rax,rax
		call 	printf
		epilogue
	print_nl:
		prologue
		mov		rdi,0xA 
		xor		rax,rax
		call	putchar
		epilogue
	print_int:
		prologue
		;arg is in rdi
		mov		rsi, rdi
		mov		rdi, dword int_format
		xor		rax,rax
		call	printf
		epilogue

	read_int:
		prologue
		;rdi is assumed to have the address of the int to be read in
		mov		rsi, rdi 
		mov		rdi, dword int_format
		xor 	rax,rax
		call	scanf
		epilogue	
