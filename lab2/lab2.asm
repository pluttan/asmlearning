extern geti
extern outi

section .data
    ia db  "Enter a: "
    ic db  "Enter b: "
    ik db  "Enter c: "
    inl equ $-ik

section .bss
    a resb 12
    c resb 12
    k resb 12
    l equ $-k

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
    mov edx, 0
    div ecx

    pop ecx
    add eax, ecx
    
    mov dword[a], eax 

    mov eax, a
    mov ecx, ia
    mov edx, inl
    call outi

    mov eax, 1
    int 80h







