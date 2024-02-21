extern geti
extern outi

section .data
    ia db  "Enter a: "
    ic db  "Enter c: "
    ik db  "Enter k: "
    ot db  "Result : "
    inl equ $-ot

section .bss
    a resb 12
    c resb 12
    k resb 12
    l equ $-k

section .text
global _start

_start:
    jmp getack   
;
getack:
    mov  eax, inl 
    mov  ecx, l
    mov  ebx, ia
    mov  edx, a
    call geti

    mov  eax, inl 
    mov  ecx, l
    mov  ebx, ic
    mov  edx, c
    call geti

    mov  eax, inl 
    mov  ecx, l
    mov  ebx, ik
    mov  edx, k
    call geti
    
    mov eax, [a]
    mov ebx, [c]
    mov ecx, [k]

    jmp calc
;
calc:
    push eax
    sub  eax, ebx
    mul  eax
    mov  edx, eax
    pop  eax
    push edx

    mov  edx, 2
    mul  edx
    push eax

    mov  eax, ebx
    mul  ebx
    mul  ebx
    push eax

    mov eax, ecx
    mul ecx
    add eax, 1
    mov ecx, eax

    pop eax
    pop ebx
    mul ebx
    cdq 
    idiv ecx

    pop ecx
    add eax, ecx
    
    jmp outandex
;
outandex:
    mov dword[a], eax 

    mov eax, a
    mov ecx, ot
    mov edx, inl
    call outi

    mov eax, 1
    int 80h
;
