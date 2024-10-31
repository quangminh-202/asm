; Задание 4. Проверить, что заданная точка (x, y) удовлетворяет 
;            условию: y ≠ cth (x*a)

%include "io64.inc"

section .data
    a: dd 2.0
    x: dd 5.0
    y: dd 6.0
    
section .bss
    res: resd 1
    res2: resd 1
    
section .text
    global main

exponential:
    movss dword[res], xmm0
    FLDl2e
    FMUL dword[res] 
    FLD1     ;загружаем +1.0 в стек
    FLD ST1  ;дублируем показатель в стек
    FPREM    ;получаем дробную часть
    F2XM1    ;возводим в дробную часть показателя
    FADD     ;прибавляем 1 из стека
    FSCALE   ;возводим в целую часть и умножаем
    FSTP dword[res] ; выталкиваем лишнее из вершины
    MOVSS xmm0, dword[res]
    ret
    
main:
   
    fld dword[x] 
    fld dword[a]
    fmul
    fstp dword[res] 
    movss xmm0, dword[res]  ; xmm0 = x*a
    addss xmm0, xmm0        ; xmm0 = 2*a*x
    
    call exponential        ; calculate e^(2ax)
     
    ; e^(2ax) + 1
    movss dword[res], xmm0
    fld dword[res]
    fld1
    fadd 
    fstp dword[res] 
    
    ; e^(2ax) - 1
    movss dword[res2], xmm0
    fld dword[res2]     ; ST(0) = res2
    fld1                ; ST(0) = 1, ST(1) =  res2
    fsubr ST1           ; ST(0) = ST(1) -  ST(0)
    fstp dword[res2] 
    
    ; cth (x*a) = (e^2(x*a) + 1) / (e^2(x*a) - 1)
    fld dword[res]
    fld dword[res2]
    fdivp
    fstp dword[res]
    
    fld dword[res]
    fld dword[y]
    fcomip 
    je .equal     
    jmp .not_equal
    
    .equal:
        PRINT_STRING "False (y = cth (x*a))"
        jmp .end
    
    .not_equal:
        PRINT_STRING "True (y ≠ cth (x*a))"
    
    .end:
        fstp ST0
        xor rax, rax
        ret