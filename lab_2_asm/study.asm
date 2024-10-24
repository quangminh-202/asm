%include "io64.inc"

section .text
global main
enable_zd_exception:
    sub rsp, 8
    fstcw [rsp] ; store the control word
    mov al, [rsp] ; get the lower byte
    and al, 11 ; clear the bit 3 (ZDivision mask bit)
    mov [rsp] , al 
    fldcw [rsp] ; load the control word
    add rsp, 8
    ret
main:
    ; uncomment below and see the results
    ; call enable_zd_exception
    fld1
    fldz
    fdiv ; 1/0
    fwait ; check and raise the exception
    xor eax, eax
    ret
