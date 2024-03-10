section .data
    tx db "aaaaaaaaaaaaaaaaaaaaaaaaaaaaa", 10
    txl equ $-tx

section .bss

section .text
global _start

_start:
    jmp txparser

txparser:
    mov ecx, 0
    mov edx, 0
    jmp txparserl

txparserl:
    mov bl, byte[tx + edx]
    inc edx

    cmp bl, 10
    je txparsere

    cmp bl, "e"
    je  txparserl
    cmp bl, "y"
    je  txparserl
    cmp bl, "u"
    je  txparserl
    cmp bl, "i"
    je  txparserl
    cmp bl, "o"
    je  txparserl
    cmp bl, "a"
    je  txparserl

    jmp txparserln

txparserln:
    mov byte[tx+ecx], bl
    inc ecx
    jmp txparserl

txparsere:
    mov edx, ecx
    lea ecx, [tx]
    mov eax, 4
    mov ebx, 1
    int 80h

    mov eax, 1
    int 80h
    

