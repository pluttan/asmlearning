section .data
    lst db 1, 2, 3, 4, 5, 6, 7, -1

section .text
global _start

_start:
    mov ecx, 0
    mov eax, 0
    jmp arrloop

arrloop:
    add al, [lst+ecx]
    
    add ecx, 1
    
    mov dl, [lst+ecx]
    cmp dl, -1
    je  exit
    
    jmp arrloop

exit:
    mov ebx, eax
    mov eax, 1
    int 80h
