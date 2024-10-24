;Задание1: реализовать функцию, округляющую введенное 
;пользователем вещественное число до ближайшего целого:
;1) вверх
%include "io64.inc"
section .rodata:
    x: dd -1.5

section .bss
    tmp: resd 1
    result: resd 1

section .text
global main

fpu_round_up:
    sub rsp,8 ; allocate space on stack
    fstcw [rsp] ; save the control word
    mov al, [rsp+1] ; get the higher 8 bits
    and al, 0xF3 ; reset the RC field to 0
    or al, 0x08 ; set the RC field to 0x10
    mov [rsp+1], al
    fldcw [rsp] ; load the control word
    add rsp, 8 ; 'free' the allocated stack space
    fld dword[x]
    fistp dword[x]
    ret
    
sse_round_up:
    stmxcsr [tmp]
    or dword [tmp], 0x00004000
    ldmxcsr [tmp]
    cvtss2si eax, xmm0 
    ret

main:
    mov rbp, rsp; for correct debugging
    fld dword[x]
    
    call fpu_round_up 
    fist dword[result] 
    mov eax, [result]
    PRINT_STRING "Method by FPU: "
    PRINT_DEC 4, eax
    NEWLINE
    
    call sse_round_up 
    fist dword[result] 
    mov eax, [result]
    PRINT_STRING "Method by SSE: "
    PRINT_DEC 4, eax
    
    xor eax, eax
    ret