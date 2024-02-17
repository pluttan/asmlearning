section .data
    a dw -30
    b dw 21

section .bss
    x resd 1

section .text
global _start

_start:
    mov eax, [a] ; eax = -30
    add eax, 5   ; eax += 5  (eax = -25)
    sub eax, [b] ; eax -= 21 (eax = -46)
    mov [x], eax ; [x] = -46

    mov eax, 1
    int 80h
