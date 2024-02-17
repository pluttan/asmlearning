section .text
global _start

_start:
    mov eax, 0b100
    shr eax, 2              ; 0b100 -> 0b1

    shl eax, 5              ; 0b1 -> 0b100000 (0x20)

    mov eax, 1
    int 80h
