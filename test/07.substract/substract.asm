section .data

section .text
global _start

_start:
    mov eax, 2
    mov ebx, 6
    sub eax, ebx
    
    mov eax, 1
    int 0x80
