%include "io64.inc"

section .rodata
    polynomial: dd 0xEDB88320
    init_crc: dd 0xFFFFFFFF
    final_crc: dd 0xFFFFFFFF

section .bss ; khai báo toàn cục và tĩnh không có dữ liệu
    data: resb 257 ; reserve byte

section .text
global main


main:
    ;mov rbp, rsp; for correct debugging
    ; i - ECX 
    ; data - RSI
    ; crc - EDX
    GET_STRING data, 256
    lea rsi, [data]  ; RSI point to data
    mov edx, [init_crc]
.cycle_start:      ; Load the address of input into RSI
    movzx eax, byte [rsi] ; Move with Zero-Extend: Copy the first byte of input into EAX
    test al, al
    jz .cycle_end
     
    xor edx, eax  
    mov ecx, 0  ; Initialize counter to 0
.bit_loop:
    mov eax, edx
    and eax, 1  ; Now EAX contains the least significant bit of EDX
    shr edx, 1 

    test eax, eax ; check if least significant bit is 0 or 1
    jz .bit_end   ; if 0, skip XOR operation
    xor edx, [polynomial] ; if 1, XOR EDX with polynomial
.bit_end:
    add ecx,1       ; Increment counter
    cmp ecx, 8    ; Compare counter with 8
    jl .bit_loop  ; If counter is less than 8, continue loop

    inc rsi
    jmp .cycle_start
.cycle_end:
    xor edx, [final_crc]
    PRINT_HEX 4, edx
    ret   