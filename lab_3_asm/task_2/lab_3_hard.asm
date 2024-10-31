%include "io64_float.inc"
%include "io64.inc"
section .rodata
    arr: dd 50, 3.0
    var_class: dq 2.0
               dd 4.0 
;namespace var3 {
;        struct S {
;           int a;
;           float b;
;        };
;        class C {
;            double c;
;            float d;
;        public:
;            void access(T s);
;               var1 = (double)sinf(s.b)
;               if c <= var1:
;                  access denied and return
;               var1 = 0
;               if 0 < d:
;                   var2 = sqrt(float(d))
;                   var1 = (float)s.a
;                   if var1 >= var2:
;                       access granted and return
;                   else: access denied and return
;               else: access denied and return
    
section .text
extern _ZN4hard4var31C6accessENS0_1SE
global main
main:
    mov rbp, rsp; for correct debugging
    mov rdx, [arr]

    lea rcx, [var_class]
    
    push rcx
    call _ZN4hard4var31C6accessENS0_1SE
    pop rcx
    xor rax, rax
    ret