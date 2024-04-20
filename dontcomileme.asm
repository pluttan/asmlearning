extern malloc
section .text
global main
main:
    mov  rdi, 0xffffffffffffffff
    call malloc
    mov  rax, 1
    int  80h
