section .data
   x dd 3.14
   y dd 3.14

section .text
global _start

_start:
    movss xmm0, [x]
    movss xmm1, [y]
    subss xmm0, xmm1
    mov   ebx,  1
    int   80h
