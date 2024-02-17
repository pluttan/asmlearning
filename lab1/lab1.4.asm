section .data
    a    dw 25
    b    dd -35
    name dw "Andrey Андрей"

section .text
global _start

_start:
    mov eax, 1
    int 80h
