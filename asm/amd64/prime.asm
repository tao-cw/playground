%include "asm_io.inc"
%macro prologue 0
    push    rbp
    mov     rbp,rsp
    push    rbx
    push    r12
    push    r13
    push    r14
    push    r15
    pushfq
%endmacro ; end of  prologue
%macro epilogue 0
    popfq
    pop     r15
    pop     r14
    pop     r13
    pop     r12
    pop     rbx
    leave
    ret
%endmacro ; end of epilogue

section .rodata
    prompt1 db  "Find primes upto: "

section .bss  
    guess   resd 1    ; uninitialized integer
    limit   resd 1    ; uninitialized integer

section .text
    global main

    main:
        prologue

        ; enter a value in the variable limit
        mov     rdi, prompt1
        call    print_string
        mov     rdi, dword limit 
        call    read_int

        ; print the first 2 prime numbers
        mov     rdi, 0x2
        call    print_int
        call    print_nl
        mov     rdi, 0x3
        call    print_int
        call    print_nl
        mov     [guess],dword 0x5

while_limit:
        mov     eax, [guess] ; since we are dealing with integers, we use the 32-bit register to move data
        mov     edx, [limit] ; since we are dealing with integers 
        cmp     eax, edx

        jnbe    end_of_while_limit ; jump if not below or equal

        mov     rcx, 3       ; RCX holds the variable factor

while_factor:
        mov     rax, rcx
        mul     rax           ; calculate factor*factor.  we could use EAX here, 
                              ; but using RAX will reduce chances of an overflow

        jo      end_of_while_factor ; we still check for overflow though with jump if overflow

        cmp     eax,[guess]   ; we compare with EAX, otherwise if we use RAX here,
                              ; 8 bytes will be read from the address of the variable guess

        jge     end_of_while_factor ; jump if greater than or equal

        mov     eax,[guess]   ; moving 4 bytes only 
        cqo
        div     rcx           ; guess / factor
        cmp     rdx,0         ; guess % factor is in RDX
        je      end_of_while_factor ; jump if equal
        add     rcx,2         ; factor+=2 
        jmp     while_factor  ; loop 

end_of_while_factor:
        mov     eax,[guess]
        cqo
        div     rcx
        cmp     rdx,0         ; guess%factor is in RDX
        je      end_of_if     ; jump if equal
        mov     edi, [guess]  ; move the value in guess into EDI for printing
        call    print_int
        call    print_nl

end_of_if:
        mov     eax, [guess]
        add     rax, 2          ; guess+=2
        mov     [guess],eax
        jmp     while_limit     ; loop 

end_of_while_limit:
        epilogue

