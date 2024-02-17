section .data
    a dd 0x25
    b dd 0x2500

section .text
global _start

_start:
    mov bl, [a]
    mov ch, [a]

    mov eax, 1
    mov ebx, 0
    int 80h
