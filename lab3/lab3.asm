extern geti
extern outi

section .data
    ia db  "Enter a: "
    ib db  "Enter b: "
    im db  "Enter m: "
    ot db  "Result : "
    inl equ $-ot

section .bss
    a resb 12
    b resb 12
    m resb 12
    l equ $-m

section .text
global _start

_start:
    mov  eax, inl 
    mov  ecx, l
    mov  ebx, ia
    mov  edx, a
    call geti

    mov  eax, inl 
    mov  ecx, l
    mov  ebx, ib
    mov  edx, b
    call geti

    mov  eax, inl 
    mov  ecx, l
    mov  ebx, im
    mov  edx, m
    call geti

    mov ebx, [b]
    mov ecx, [m]
    cmp ecx, 0
    jl  f1
    jmp f2

f1:
    mov  eax, [a]
    cmp  eax, 0
    add  eax, ebx
    cdq
    idiv ecx
    jmp  exit

f2:
    mov  eax, ebx
    imul ebx
    imul ebx
    mov  ebx, eax
    mov  eax, ecx
    imul ecx
    add  eax, ebx
    jmp  exit

exit:
    mov dword[a], eax 

    mov eax, a
    mov ecx, ot
    mov edx, inl
    call outi

    mov eax, 1
    int 80h

