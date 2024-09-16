; struct Link {
; 	int data;	
; 	struct Link* prev;
; 	struct Link* next;
;	};
%define data_offset		0
%define prev_offset		8
%define next_offset		16
%define size_of_list	24

%define RAND_MAX		2147483647

%define sys_getpid		39

section .rodata
	prompt1	db "Winnings: %ld in %ld chances.",10,0
	int_format0 db	"win : %ld ",10,0
	int_format1 db "loss: %ld ",10,0
	int_format2 db "AMT: %ld ",10,0

section .text
	global	get_bet, get_amt, add_to_list, remove_from_list
	global	main
	extern	printf
	extern	srand, rand
	extern  malloc, free

	main:
		; prologue with making space for temporary variables on stack
		push	rbp
		mov		rbp, rsp
		push	rbx
		push	r12
		push	r13
		push	r14
		push	r15
		pushf	
		; do we need stack variables ?
		; let us use the multitude of registers available to us
		; let R12 be head of the doubly-linked list
		; let R13 be tail of the doubly-linked list
		; let R14 be the winnings at the end
		; let R15 be the number of chances
		xor		r12, r12
		xor		r13, r13
		xor		r14, r14
		xor		r15, r15	
		
		; First fill in the first 4 elements of the list
		xor		rax,rax
		mov		rdi, size_of_list
		call	malloc
		mov		r12, rax
		mov		[r12 + data_offset], dword 1
		xor		rax, rax
		mov		[r12 + prev_offset], rax
		mov		rdi, size_of_list
		call	malloc
		mov		[r12 + next_offset], rax 	
		mov		[rax + data_offset], dword 2
		mov		[rax + prev_offset], r12
		push	rax
		mov		rdi, size_of_list		
		xor		rax, rax
		call	malloc
		pop		r8
		mov		[r8 + next_offset], rax
		mov		[rax + data_offset], dword 3
		mov		[rax + prev_offset], r8
		push	rax
		mov		rdi, size_of_list
		xor		rax, rax
		call	malloc
		pop		r8
		mov		[r8 + next_offset], rax
		mov		r13, rax
		mov		[r13 + data_offset], dword 4
		mov		[r13 + prev_offset], r8
		xor		rax, rax
		mov		[r13 + next_offset], rax
	
		mov		rax, sys_getpid
		syscall
		mov		rdi, rax
		call	srand
while_loop:
		cmp		r12,0
		jz		print_result
		cmp		r13,0 
		jz		print_result
		mov		rsi, r13
		mov		rdi, r12
		call	get_amt
		push	rax
		inc		r15
		
		mov		rsi, rax
		mov		rdi, dword int_format2
		xor		rax, rax
		call	printf

		call	get_bet
		pop		r10
		cmp		rax, 18
		jg		loss_block
win_block:
		add		r14, r10
		mov		rsi, r13
		mov		rdi, r12
		xor		rax, rax
		call	remove_from_list
		mov		rsi, r14
		mov		rdi, dword int_format0
		xor		rax, rax
		call	printf
		jmp 	while_loop
loss_block:
		sub		r14, r10
		mov		rsi, r10
		mov		rdi, r13
		call	add_to_list
		mov		r13, rax
		mov		rsi, r14
		mov		rdi, dword int_format1
		xor		rax, rax
		call	printf
		jmp		while_loop

print_result:
		mov		rdx, r15
		mov		rsi, r14
		mov		rdi, dword prompt1
		xor		rax, rax
		call	printf
		; epilogue with return value 0
		xor		rax,rax
		popf
		pop		r15
		pop		r14
		pop		r13
		pop		r12
		pop		rbx
		mov		rsp, rbp
		pop		rbp
		ret


remove_from_list:
		push	rbp
		mov		rbp, rsp
		push	rsi
		cmp		rdi, rsi
		je		free_tail_only
		cmp		rdi, 0
		jz		free_tail_only
		mov		r12, [rdi + next_offset]
		call	free ; on rdi
		cmp		r12, 0
		jz		free_tail_only
		xor		rcx, rcx
		mov		[r12 + prev_offset], rcx
free_tail_only:		
		pop		rsi
		mov		rcx, rsi	
		cmp		rsi, 0
		jz 		ret_frm_rmvfrmlist
		mov		r13, [rsi + prev_offset]
		mov		rdi, rsi
		call	free
		cmp		r13, 0
		jz 		ret_frm_rmvfrmlist
		xor		rcx, rcx
		mov		[r13 + next_offset],rcx 
ret_frm_rmvfrmlist:	
		xor		rax, rax
		mov		rsp, rbp
		pop		rbp
		ret

add_to_list:
		push	rbp
		mov		rbp, rsp
		push	rsi
		push	rdi
		mov		rdi, size_of_list
		call	malloc	
		pop		rdi
		pop		rsi
		mov		[rdi + next_offset], rax
		cmp		rax, 0
		jz		ret_frm_add2list
		mov		[rax + data_offset], rsi
		xor		rcx, rcx
		mov		[rax + next_offset],rcx 
		mov		[rax + prev_offset], rdi
ret_frm_add2list:
		mov		rsp, rbp
		pop		rbp
		ret

get_amt:
		push	rbp
		mov		rbp, rsp
		mov		rax, [rdi + data_offset]
		xor		rcx, rcx
		cmp		[rdi + next_offset],rcx
		jz		ret_frm_getamt
		add		rax, [rsi + data_offset]
ret_frm_getamt:
		mov		rsp, rbp
		pop		rbp
		ret

get_bet:
		push	rbp
		mov		rbp, rsp
		push	38
		push 	RAND_MAX
		call	rand
		push	rax
		fild	qword [rbp - 24] ; rax
		fild	qword [rbp - 8]  ; 38
		fmulp	st1
		fild	qword [rbp - 16] ; RAND_MAX
		fld1
		faddp	st1
		fdivp	st1
		fistp	qword [rbp - 24]
		mov		rax, [rbp -24]
		mov		rsp, rbp
		pop		rbp
		ret
