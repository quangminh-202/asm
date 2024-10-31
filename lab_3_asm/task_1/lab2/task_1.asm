;Задание1: реализовать функцию, округляющую введенное 
;пользователем вещественное число до ближайшего целого:
;1) вверх

extern printf
extern scanf

section .data
    fmt_fpu db "Method by FPU: %d", 13, 10, 0
    fmt_sse db "Method by SSE: %d", 13, 10, 0
    fmt_scan db "%f", 0

section .text
global main

fpu_round_up:
    push rbp
    mov rbp, rsp
    sub rsp, 32                   ; Shadow space

    movss [rsp+8], xmm0          ; Lưu số float từ xmm0 vào stack
    
    fstcw [rsp]
    mov al, [rsp+1]               
    and al, 0xF3                  
    or al, 0x08                   
    mov [rsp+1], al
    fldcw [rsp]                   
    
    fld dword [rsp+8]           
    fistp dword [rsp+8]
    mov eax, [rsp+8] 
    
    leave
    ret

sse_round_up:
    push rbp
    mov rbp, rsp
    sub rsp, 32                   ; Shadow space RCX RDX R8 R9 XMM0-3
    
    stmxcsr [rsp] ;Store MXCSR multimedia extensions control and status register
    or dword [rsp], 0x00004000
    ldmxcsr [rsp] ; load MXCSR
    cvtss2si eax, xmm0     
    
    leave
    ret

main:
    push rbp
    mov rbp, rsp
    sub rsp, 80                   ; 32 (shadow) + 48 (local vars) = 80 (bội của 16)

    ; read float
    lea rdx, [rsp+32]            ; address float
    lea rcx, [fmt_scan]          ; Format string
    call scanf

    ; call fpu_round_up
    movss xmm0, [rsp+32]         ; float to xmm0
    call fpu_round_up
    
    ; printf result FPU
    mov rdx, rax                 ; interger result
    lea rcx, [fmt_fpu]           ; Format string
    call printf

    ; call sse_round_up
    movss xmm0, [rsp+32]         ; float to xmm0
    call sse_round_up
    
    ; printf result SSE
    mov rdx, rax
    lea rcx, [fmt_sse]
    call printf

    xor rcx, rcx  
    leave  
    ret