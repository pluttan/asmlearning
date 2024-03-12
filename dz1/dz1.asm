extern outi

section .data
    ittx  db  "Enter text: "
    ittxl equ $-ittx
    ottx  db  "There are "
    ottxl equ $-ottx
    ottt  db  " letter(s) 'p' in word "
    otttl equ $-ottt

section .bss
    ota resb 4
    tx  resb 255
    txl equ  255

section .text
global _start

_start:
    mov edx, ittxl
    mov ecx, ittx
    mov eax, 4
    mov ebx, 1
    int 80h

    mov eax, 3
    mov ebx, 0
    mov ecx, tx
    mov edx, txl
    int 80h
    
    jmp txparser
;
txparser:
    mov ecx, 1
    mov esi, 0
    jmp txparserls
;
txparserls:
    sub ecx, 1
    lea edx, [tx+ecx]
    mov eax, 0
    jmp txparserl
;
txparserl:
    mov bl,  byte[tx+ecx]
    inc ecx

    cmp bl, 10
    je  txparsere

    cmp bl, " "
    je  txparserlsp

    cmp edx, 0
    je  txparserls
    
    cmp bl, "p"
    je  txparserlcmpiax

    cmp bl, "P"
    je  txparserlcmpiax

    jmp txparserl
;
txparserlsp:
    cmp edx, 0
    jne txparserlpr
    jmp txparserl
;
txparserlpr:
    mov  [ota], eax
    push eax
    push ebx
    push ecx

    add  ecx, tx
    sub  ecx, edx
    push edx
    push ecx

    mov eax, ota
    mov ecx, ottx
    mov edx, ottxl
    call outi

    mov edx, otttl
    mov ecx, ottt
    mov eax, 4
    mov ebx, 1
    int 80h

    pop edx
    pop ecx
    mov eax, 4
    mov ebx, 1
    int 80h
    
    mov dword[ota], 10
    mov edx, 1
    mov ecx, ota
    mov eax, 4
    mov ebx, 1
    int 80h

    mov edx, 0
    pop ecx
    pop ebx
    pop eax

    cmp esi, 0
    je  txparserl
    jmp txparseree
;
txparserlcmpiax:
    add eax, 1
    jmp txparserl    
;
txparsere:
    mov esi, 1
    jmp txparserlpr
;
txparseree:
    mov eax, 1
    int 80h
;
