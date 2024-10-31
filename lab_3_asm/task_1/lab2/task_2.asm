; Задание 2: Реализовать приближенное вычисление логарифма по
;            основанию 2 инструкциями SSE в диапазоне |x|<1.
; log2(1+x) = 1/ln2(x-x^2/2 + x^3/3 - x^4/4 + ...) Taylor
%include "io64.inc"

section .rodata
    x: dd 0.5
    iter_number: dd 100
    const_1: dd 1.0
    const_minus_1: dd -1.0
    const_ln2: dd 0.693147181  ; ln(2)

section .bss
    res: resd 1

section .text
global main
main:
    ; check x bounds (-1 <= x <= 1)
    movss xmm0, dword[x]
    movss xmm1, dword[const_1]
    movss xmm2, dword[const_minus_1]
    
    comiss xmm0, xmm1         ; compare x with 1
    jae x_out_of_bounds
    comiss xmm2, xmm0         ; compare -1 with x
    ja x_out_of_bounds
    
    ; initialize variables
    mov edx, dword[iter_number]   ; counter
    xorps xmm6, xmm6             ; sum = 0
    movss xmm7, dword[x]         ; current x power
    xor ebx, ebx                 ; sign flag (0 = positive, 1 = negative)
    mov eax, 1                   ; current denominator

    .cycle:
        movss xmm0, xmm7         ; copy current x power
        cvtsi2ss xmm1, eax       ; convert denominator to float
        divss xmm0, xmm1         ; term = x^n / n
        
        test ebx, ebx            ; check sign
        jnz .subtract
        addss xmm6, xmm0         ; add term if positive
        jmp .continue
        
    .subtract:
        subss xmm6, xmm0         ; subtract term if negative
        
    .continue:
        xor ebx, 1               ; toggle sign
        mulss xmm7, dword[x]     ; calculate next power
        inc eax                  ; increment denominator
        dec edx                  ; decrement counter
        jnz .cycle

    ; multiply by 1/ln(2)
    movss xmm0, xmm6
    divss xmm0, dword[const_ln2]
    movss dword[res], xmm0
    
    NEWLINE
    
    end:
    xor rax, rax
    ret
    
x_out_of_bounds:
    PRINT_STRING "Error: Should be -1 <= x <= 1"
    NEWLINE
    jmp end