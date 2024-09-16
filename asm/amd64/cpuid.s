	.global _start

_start:
	xor    %eax,%eax
	cpuid
	shl    $0x20,%rdx
	xor    %rbx,%rdx
	push   %rcx
	push   %rdx
	mov    $0x10,%edx
	mov    %rsp,%rsi
	push   $0x1
	pop    %rax
	mov    %rax,%rdi
	syscall
	mov    $0x3c,%eax
	xor    %rdi,%rdi
	syscall
