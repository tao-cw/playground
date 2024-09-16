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
;%define DEBUG_PRINT 1

section .rodata

    int_prompt      db "%d",0
    float_prompt    db "%0.03f | ",0
    prompt2         db "The square of the matrix is: ",10,0
    prompt1         db "Enter the size of the Hilbert matrix:",0

section .text
    global  main, create_hilbert_matrix, square_float_matrix, print_float_matrix
    extern  printf, scanf, malloc, free
    extern  print_int,print_nl
    main:
        push    rbp
        mov     rbp, rsp
        sub     rsp, 8
        push    rbx
        push    r12
        push    r13
        push    r14
        push    r15
        ; Enter the size of the matrix
        xor     rax, rax
        mov     rdi, dword prompt1
        call    printf
        xor     rax, rax
        lea     rsi, [rbp-8]
        mov     rdi, dword int_prompt
        call    scanf
        
        ; print the number entered    
        xor     rax, rax
        xor     rdi, rdi
        mov     rdi, [rbp-8]
        call print_int
        call print_nl
    
        ; Create a Hilbert Matrix
        xor     rax, rax
        xor     rdi, rdi
        mov     rdi, [rbp-8]
        call    create_hilbert_matrix
        mov     rbx, rax              ; store a pointer to the Hilbert matrix      
        push rbx
        push rax
        mov     rsi, rax
        xor     rdi, rdi
        mov     rdi, [rbp-8]
        call    print_float_matrix
        call print_nl
        pop rax 
        
        ; Calculate the Square of a floating point matrix
        ; Arguments are the size of the matrix and the pointer to the input matrix
        ; Return value is the pointer to the square of the input matrix
        mov     rsi, rax
        xor     rdi, rdi
        mov     rdi, [rbp-8]
        call    square_float_matrix
        mov     r12, rax              ; store a pointer to the square of the Hilbert matrix
        push r12
        ; Print the square of the Hilbert Matrix on the screen.
        mov     rsi, rax
        xor     rdi, rdi
        mov     rdi, [rbp-8]
        call    print_float_matrix
        call    print_nl
        pop r12
        ; End the program and free memory
        mov     rdi, r12
        xor     rax, rax
        call    free
        pop rbx
        mov     rdi, rbx
        xor     rax, rax
        call    free
        epilogue

    create_hilbert_matrix:
        prologue
        ; size of the matrix is in RDI
        mov     r15, rdi
        imul    rdi, rdi
        imul    rdi, 4          ; sizeof(float)
        ; size of the memory to be allocated in RDI now
        xor     rax, rax
        call    malloc
        ; store a copy of the memory location pointing to the matrix.
        mov     r11, rax
        mov     rbx, rax
        push rax
        push r11
        xor     rcx, rcx
outer_loop_start:
        cmp     rcx, r15
        jge     outer_loop_end
        xor     r12, r12
inner_loop_start:
        cmp     r12, r15
        jge     inner_loop_end

        ; each element is RCX+RDX+1
        mov     rdi, 1
        add     rdi, rcx
        adc     rdi, r12
      
        ; convert the integer in RDI to a single precision floating point in XMM0
        pxor xmm0, xmm0
        pxor xmm1, xmm1
        cvtsi2ss xmm0, rdi
        ; calculate the reciprocal of the single precision floating point in XMM0 and place it in XMM1
        rcpss   xmm1, xmm0
        ; place the value in XMM1 in memory allocated for the matrix
        movss    dword[rbx], xmm1

        ; Print the the Hilbert Matrix on the screen.
%ifdef DEBUG_PRINT
        push rbx
        push rax
        push rdx
        push rdi
        push rcx
        push r12
        push r15
        ; for printf we need to store the single precision as double precision
        cvtss2sd xmm0, dword[rbx]
        mov     rdi, dword float_prompt
        mov     rax, 1 ; Number of XMM registers to use
        call    printf
        pop r15
        pop r12
        pop rcx
        pop rdi
        pop rdx
        pop rax
        pop rbx
%endif

        add     rbx, 4          ; sizeof(float) 
        inc     r12
        jmp     inner_loop_start
inner_loop_end:
        ; Print the the Hilbert Matrix on the screen.
%ifdef DEBUG_PRINT
        push rbx
        push rax
        push rdx
        push rdi
        push rcx
        push r12
        push r15
        call print_nl
        pop r15
        pop r12
        pop rcx
        pop rdi
        pop rdx
        pop rax
        pop rbx
%endif
        inc     rcx
        jmp     outer_loop_start
outer_loop_end:
        pop     r11
        pop     rax
        mov     rax, r11
        epilogue

square_float_matrix:
         prologue
        ; the Hilbert matrix pointer is in RSI
        mov     r14, rsi
        ; size of the matrix is in RDI
        mov     r15, rdi
        imul    rdi, rdi
        imul    rdi, 4          ; sizeof(float)
        push   r15
        push   r14
        ; size of the memory to be allocated in RDI now
        xor     rax, rax
        call    malloc
        ; store a copy of the memory location pointing to the matrix.
        mov     rbx, rax
        mov     r12, rax
        pop     r14
        pop     r15
        push    rax
        push    rbx
        ; start squaring the matrix
        xor     rcx, rcx
forloop_1:
        cmp     rcx, r15
        jge     end_forloop_1
        xor     rsi, rsi
forloop_2:
        cmp     rsi, r15
        jge     end_forloop_2
        xor     rdi, rdi
        ; B[i][j] = 0.0 in XMM0
        pxor     xmm0, xmm0
        cvtsi2ss xmm0, rdi
forloop_3:
        cmp     rdi, r15
        jge     end_forloop_3
        ; B[i][j]+= A[i][k]*A[k][j]
        mov     rax, r15
        imul    rax, rcx
        add     rax, rdi
        mov     r8, r15
        imul    r8, rdi
        add     r8, rsi
        pxor    xmm1, xmm1
        pxor    xmm2, xmm2
        movss    xmm1, dword[r14 + rax*4]
        movss    xmm2, dword[r14 + r8*4]
        mulss   xmm1, xmm2
        addss   xmm0, xmm1
        inc     rdi
        jmp     forloop_3
end_forloop_3:
        ; B[i][j] = XMM0
        movss    dword[r12], xmm0
        add     r12, 4 ; sizeof(float)
        inc     rsi
        jmp     forloop_2
end_forloop_2:
        inc     rcx
        jmp     forloop_1
end_forloop_1:
        pop     rax
        pop     rbx
        mov     rax, rbx
        epilogue


print_float_matrix:
        prologue
        ; size of the matrix is in RDI and pointer is in RSI
        mov     r15, rdi
        mov     rbx, rsi
        xor     rcx, rcx
floop_1:
        cmp     rcx, r15
        jge      end_floop_1 
        xor     r12, r12
floop_2:
        cmp     r12, r15
        jge     end_floop_2

        push rbx
        push rax
        push rdx
        push rdi
        push rcx
        push r12
        push r15
        ; for printf we need to store the single precision as double precision
        cvtss2sd xmm0, dword[rbx]
        mov     rdi, dword float_prompt
        mov     rax, 1 ; Number of XMM registers to use
        call    printf
        pop r15
        pop r12
        pop rcx
        pop rdi
        pop rdx
        pop rax
        pop rbx

        add     rbx, 4
        inc     r12
        jmp     floop_2
end_floop_2:
        ; Print the the Hilbert Matrix on the screen.
        push rbx
        push rax
        push rdx
        push rdi
        push rcx
        push r12
        push r15
        call print_nl
        pop r15
        pop r12
        pop rcx
        pop rdi
        pop rdx
        pop rax
        pop rbx

        inc     rcx
        jmp     floop_1
end_floop_1:
        xor     rax, rax
        epilogue
