extern ExitProcess
extern printf
extern scanf
extern malloc
extern free

section .rodata
    polynomial: dd 0xEDB88320
    init_crc: dd 0xFFFFFFFF
    final_crc: dd 0xFFFFFFFF 
    fmt_input: db "%s", 0
    fmt_output: db "%08X", 10, 0
    error_msg: db "Memory allocation failed!", 10, 0

section .text
global main

main:
    push rbp
    mov rbp, rsp
    sub rsp, 32                    ; Căn chỉnh stack 16-byte
    
    ; Cấp phát bộ nhớ động
    mov rcx, 257                   ; Windows x64 sử dụng rcx cho tham số đầu tiên
    call malloc
    test rax, rax                  ; Kiểm tra malloc có thành công không
    jz error_handler               ; Nếu malloc thất bại

    mov r12, rax                   ; Lưu địa chỉ buffer vào r12
    
    ; Đọc input string
    mov rcx, fmt_input            ; Windows: tham số 1 trong rcx
    mov rdx, r12                  ; Windows: tham số 2 trong rdx
    call scanf
    
    ; Tính CRC
    mov edx, [init_crc]
    mov rsi, r12

.cycle_start:
    movzx eax, byte [rsi]
    test al, al
    jz .cycle_end
     
    xor edx, eax  
    xor ecx, ecx

.bit_loop:
    mov eax, edx
    and eax, 1
    shr edx, 1 

    test eax, eax
    jz .bit_end
    xor edx, [polynomial]

.bit_end:
    inc ecx
    cmp ecx, 8
    jl .bit_loop

    inc rsi
    jmp .cycle_start

.cycle_end:
    xor edx, [final_crc]
    
    ; In kết quả
    mov rcx, fmt_output          ; Windows: tham số 1 trong rcx
    mov edx, edx                 ; Windows: tham số 2 trong rdx
    call printf
    
    ; Giải phóng bộ nhớ
    mov rcx, r12                 ; Windows: tham số trong rcx
    call free

    xor eax, eax                 ; Return 0
    leave
    ret

error_handler:
    ; In thông báo lỗi
    mov rcx, error_msg
    call printf
    mov ecx, 1                   ; Exit code = 1
    call ExitProcess
