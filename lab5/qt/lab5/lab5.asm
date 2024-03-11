extern _ZN10MainWindow8printstrEPci
global _ZN10MainWindow8parseasmEPc

_ZN10MainWindow8parseasmEPc:
    push rdx
    push rdi
    push rsi
    push rax
    push rbx
    push rcx
    jmp txparser

txparser:
    mov rcx, 0
    mov rdx, 0
    jmp txparserl

txparserl:
    mov bl, byte[rsi + rdx]
    inc rdx

    cmp bl, 96
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
    mov byte[rsi+rcx], bl
    inc rcx
    jmp txparserl

txparsere:
    mov edx, ecx
    pop rcx
    pop rbx
    pop rax
    call _ZN10MainWindow8printstrEPci
    pop rsi
    pop rdi
    pop rdx

    ret
    

