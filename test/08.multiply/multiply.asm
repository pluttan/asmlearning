section .text
global _start

_start:
    mov  al, 0xff
    mov  bl, 3
    ;mul  bl
    imul bl

    mov eax, 1
    int 80h
