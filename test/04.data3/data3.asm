section .data
    char DB 'A'
    list DB 1,2,3,4,-1
    str1 DB "ABA",0
    str2 DB "CDE",0

section .text
global _start

_start:
    mov bl, [char]
    mov cl, [list]
    mov dl, [str1]
    mov eax, 1
    int 80h
