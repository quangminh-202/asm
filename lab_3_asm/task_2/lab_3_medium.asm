%include "io64_float.inc"
section .rodata
    arr: dd 1, -20000000.0
;namespace var3 {
;        struct S {
;            int a;
;            float b;
;        };
;        void access(int d,S const&, int c);
;               
;               var1 = float(S.a) + b
;               var2 = S.a - S.b
;               if var 1 < var 2:
;         
;                   if d!=c:
;                        print("Acess granted")
;                        return
;                else print("Acess denied")                
;}

section .text
extern _ZN6medium4var36accessEiRKNS0_1SEi
global main
main:
    mov rbp, rsp; for correct debugging
    lea rdx,[arr]
    mov ecx, [arr]
    mov r8d, 0
    call _ZN6medium4var36accessEiRKNS0_1SEi
    ;write your code here
    xor rax, rax
    ret