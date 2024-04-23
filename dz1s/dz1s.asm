section .data
    enterl    db  "Enter your line: "
    enterlen  equ $-enterl
    output    db  "Answer: "
    outputlen equ $-output

section .bss
    words resb 56
    buf resb 6

section .text
global _start

_start:
    mov eax, 4
    mov ebx, 1
    lea ecx, [enterl]
    mov edx, enterlen
    int 80h

    mov eax, 3
    mov ebx, 0
    lea ecx, [words]
    mov edx, 56
    int 80h

    mov eax, 0
    lea esi, [words]
    dec esi

loop:
    inc eax
    mov ebx, eax
    and ebx, 1
    cmp ebx, 1
    jne swap
    add esi, 8
    cmp eax, 7
    jg  end
    jmp loop

swap:
    cld
    lea edi, [buf] 
    mov ecx, 6 
    rep movsb

    sub esi, 7
    
    mov ecx, 6

.loop:
    sub  ecx, 6
    neg  ecx
    mov  bh, [buf + ecx]
    neg  ecx
    add  ecx, 6
    mov  [esi + ecx], bh

    dec  ecx
    jcxz swap.end
    jmp  swap.loop

.end:
    add esi, 7
    jmp loop

end:
    mov eax, 4
    mov ebx, 1
    lea ecx, [output]
    mov edx, outputlen
    int 80h

    mov eax, 4
    mov ebx, 1
    lea ecx, [words]
    mov edx, 55
    int 80h

    mov eax, 1
    int 80h

