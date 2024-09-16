%include "asm_io.inc"
%macro prologue 0
        push    rbp
        mov     rbp,rsp
        push    rbx
        push    r12
        push    r13
        push    r14
        push    r15
%endmacro
%macro epilogue 0
        pop     r15
        pop     r14
        pop     r13
        pop     r12
        pop     rbx
        leave
        ret
%endmacro

section .bss
    input   resd    1

section .rodata
    prompt     db  "Enter a number: ",0
    promptlen  equ $-prompt
    cube       db  "The cube of the number is: ",0
    square     db  "The square of the number is: ",0
    cube25     db  "The value of cube of the number times 25 is: ",0
    quotient   db "The quotient of cube/100 is: ",0
    remainder  db  "The remainder of cube/100 is: ",0
    negation   db  "The negation of the remainder is: ",0
    
section .text
    global main
    main:
        prologue
        ; print the prompt for the user
        mov     rdx, promptlen
        mov     rsi, dword prompt
        push    0x1
        pop     rdi
        mov     rax,rdi
        syscall

        ; read the integer
        mov     rdi, dword input
        call    read_int

        ; calculate its square and print the output
        mov     rdi, dword square
        call    print_string
        mov     rdi, [input]
        imul    rdi, rdi
        mov     rbx, rdi
        call    print_int
        call    print_nl

        ; calculate its cube and print the output
        mov     rdi,dword cube
        call    print_string
        mov     rdi, [input]
        imul    rdi,rdi
        imul    rdi,[input]
        mov     rbx, rdi
        call    print_int
        call    print_nl

        ; calculate the cube times 25 and print the output
        mov     rdi, dword cube25
        call    print_string
        mov     rdi, rbx
        imul    rdi,0x19
        call    print_int
        call    print_nl

        ; calculate cube/100 and print the output
        mov     rdi, dword quotient
        call    print_string
        ; initialize rax and sign extend it to rdx
        mov     rax,rbx
        cqo
        mov     rcx,0x64         ; this is the hex representation of 100
        idiv    rcx
        push    rdx
        mov     rdi, rax
        call    print_int
        call    print_nl

        ; calculate the remainder of cube/100 and print the output
        mov     rdi, dword remainder
        call    print_string
        pop     rdx
        mov     rdi,rdx
        push    rdx
        call    print_int
        call    print_nl

        ; calculate the negation of the remainder and print the output
        mov     rdi, dword negation
        call    print_string
        pop     rdi
        neg     rdi
        call    print_int
        call    print_nl
        epilogue
