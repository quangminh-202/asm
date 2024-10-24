; Задание 2: Реализовать приближенное вычисление логарифма по
;            основанию 2 инструкциями SSE в диапазоне |x|<1.
; log2(1+x) = 1/ln2(x-x^2/2 + x^3/3 - x^4/4 + ...) Taylor
%include "io64.inc"

section .rodata
    x: dd 0.5
    iter_number: dd 100

section .bss
    res: resd 1

section .text
global main
main:
    
    ; check x >= 1
    mov eax, -1
    cvtsi2ss xmm0, eax
    comiss xmm0, dword[x]
    jae x_out_of_bounds ;jump if above or equal
    
    ; check x <= -1
    mov eax, 1
    cvtsi2ss xmm0, eax
    comiss xmm0, dword[x]
    jbe x_out_of_bounds ; jumb ij below or equal CF ZF
    
    mov edx, dword[iter_number] ;edx = count
    mov eax, 0 ; nay de tinh trong ()
    mov ebx, 1 ; cai dung de chuyen +-
    cvtsi2ss xmm6, eax ; xmm6 =0
    movss xmm7, dword[x] ; xmm7 = x

    .cycle:
        movss xmm0, xmm7 ; xmm0 = x
        add eax, 1 ; tăng lên 1 eax = xmm1
        call find_row_term ;xmm0 (x) = xmm0 (x)/xmm1(eax)
        mulss xmm7, dword[x] ; nhân phát xmm7 *= x
        cmp ebx, 1 ; so sanh voi 1
        jnz .not_equal ; khong bang la nhay
        mov ebx, 0 ; lai chuyen ve 0
        addss xmm6, xmm0 ; xmm6 = xmm6 + xmm0
        jmp .end_if ;
        .not_equal:
            mov ebx, 1
            subss xmm6, xmm0 ; xmm6 = xmm6 - xmm0
        .end_if:
        sub edx, 1 ; giam edx đi 100 --
        jnz .cycle
    movss dword[res], xmm6
    fld dword[res]
    fldl2e
    fmul
    fstp dword[res]
    ;PRINT_STRING "Approximation of log2(1 + x): "
    ;PRINT_FLOAT 4, res ;???
    NEWLINE
    end:
    xor rax, rax
    ret
    
x_out_of_bounds:
    PRINT_STRING "Error: Should be -1 <= x <= 1"
    NEWLINE
    jmp end
    
find_row_term: ; dau vao la thanh ghi eax
    cvtsi2ss xmm1, eax ; chuyen doi thanh so thcu don
    movss dword[res], xmm0 ;chuyen xmm0 vao res 4 byte
    fld dword[res] ;dua vao de xu ly
    movss dword[res], xmm1 ;chueyn xmm1 vao res 
    fld dword[res] ; tai len
    fdiv ; thuc hien phep chia xmm0/ xmm1
    fstp dword[res] ; float store pop
    
    movss xmm0, dword[res] ; gia tri tra ve là xmm0
    ret