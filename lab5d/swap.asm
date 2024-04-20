section .data
st db "Hello123456789 world nice to meet you", 10
stl equ $-st

section .bss
resb 255

section .text
global _start

_start:
    mov  eax, 0
    mov  ebx, 21
    lea  ecx, [st]
    call swap
    mov eax, 4
    mov ebx, 1
    mov edx, 100
    int 80h
    mov eax, 1
    int 80h

swap:
    push eax
    push ebx
    push edx
    push esi
    push edi
    push ecx
    
    add  eax, ecx
    add  ebx, ecx

    mov  ecx, ebx
    call len
    mov  esi, edi

    mov  ecx, eax 
    call len

    cmp edi, esi
    je  swap.eq 
    jl  swap.ls
    jg  swap.gr

.eq:
    mov esi, 0
    jmp swap.eql

.eql:
    mov dl, byte[eax + esi]
    mov dh, byte[ebx + esi]
    mov byte[ebx + esi], dl
    mov byte[eax + esi], dh

    inc esi
    cmp esi, edi
    jne swap.eql
    jmp swap.e

.ls:
    mov eax, 1
    mov ebx, 1
    int 80h

.gr:
    mov  edx, stl
    add  edx, eax
    pop  ecx
    push ecx
    sub  edx, ecx

    mov  ecx, ebx
    add  ecx, esi
    dec  ecx

    push ebx
    mov  ebx, edi
    sub  ebx, esi

    call exbuf
    pop  ebx

    jmp  swap.e

.e:
    pop ecx
    pop edi
    pop esi
    pop edx
    pop ebx
    pop eax
    ret

; ebx - len
; ecx - buf
; edx - size
exbuf:
    push eax
    push ecx
    push edx
    add  ecx, edx
    jmp exbuf.l

.l:
    mov al, byte[ecx]
    mov byte[ecx + ebx], al
    dec ecx
    dec edx
    cmp edx, 0
    je  exbuf.e
    jmp exbuf.l

.e:
    pop edx
    pop ecx
    pop eax
    ret

;ecx - begin of word
len:
    push eax
    mov  edi, 0

.l:
    mov al, byte[ecx + edi]
    cmp al, " "
    je  len.e
    cmp al, 10
    je  len.e
    inc edi
    jmp len.l

.e:
    pop eax
    ret
    
