section .data
    num2 db 3 dup(2)

section .bss
    num resb 3

section .text
global _start

_start:
    mov bl,         1
    mov ecx,        [num2]
    mov [num],      ebx
    mov [num+1],    bh
    mov [num+2],    bl
    mov eax,        1
    int 80h
