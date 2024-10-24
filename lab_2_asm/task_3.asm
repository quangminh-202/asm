; Задание 3. Решить уравнение:
; 2) log2(𝑡𝑔(𝑥 + 𝑎) ) = b
; x = arctan(2^b) - a
; ПОЛИЗ 2 b ^ arctan() a -

%include "io64.inc"

section .bss
    x: resd 1
    
section .rodata
    a dd 5.0
    b dd 0.5
    two dd 2.0
    
section .text
global main
main:
   
    call callculate
   
    fld dword[a]
    fsub
    fstp dword[x]
    xor rax, rax
    ret

callculate:
    fld dword[b]
    fld dword[two]     
    
    FYL2X    ;вычисляем показатель
    FLD1     ;загружаем +1.0 в стек
    FLD ST1  ;дублируем показатель в стек
    FPREM    ;получаем дробную часть
    F2XM1    ;возводим в дробную часть показателя
    FADD     ;прибавляем 1 из стека
    FSCALE   ;возводим в целую часть и умножаем
    FSTP ST1 ; выталкиваем лишнее из вершины
    fld1
    fpatan ; st1 = arctan(st1/st0)
    
    ret