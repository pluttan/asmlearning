section .data
    f1 dw 65535 ; 0xffff
    f2 dd 65535 ; 0x0000ffff

section .text
global _start

_start:
    mov ax,  [f1]
    mov ebx, [f2]
    add ax,  1    ; 0x0000, OF
    add ebx, 1    ; 0x00010000

    mov eax, 1
    int 80h
