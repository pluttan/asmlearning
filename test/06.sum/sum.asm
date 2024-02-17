section .data

section .text
global _start

_start:
    mov al, 0b1111
    mov bl, 1
    add al, bl
    adc ah, 0
    mov eax, 1
    int 80h
