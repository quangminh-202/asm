section .text
global main
extern access6
main:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    
    call access6
    mov rsp, rbp
    pop rbp
    xor rax, rax
    ret
