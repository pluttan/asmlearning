section .text
global _start

_start:
    mov eax, 3
    mov ebx, 2
    cmp eax, ebx
    jl  gen         ; not execute
    jg  out

gen:
    mov ecx, 4
    cmp eax, ecx
    je  out

out:
    mov eax, 1
    int 80h
