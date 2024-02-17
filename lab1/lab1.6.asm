section .data
    f1 dw 65535 ; 0xffff
    f2 dd 65535 ; 0x0000ffff

section .text
    add [f1], 1   ; 0x0000, OF
    add [f2], 1   ; 0x00010000

    mov eax, 1
    int 80h
