section .data
st db "Hello world i wannt to be swapped"
stl equ $-st

section .text
global _start

_start:
    mov  eax, 6
    mov  ebx, 14
    lea  ecx, [st]
    call swap
    mov eax, 4
    mov ebx, 1
    mov edx, stl
    int 80h
    mov eax, 1
    int 80h

swap:
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi

    add  ecx, ebx
    call len
    sub  ecx, ebx
    mov  esi, edi

    add  ecx, eax 
    call len
    sub  ebx, eax

    cmp edi, esi
    je  swap.eq 

.eq:
    mov dl, byte[ecx + edi - esi]
    mov dh, byte[ecx + edi - esi + ebx]
    mov byte[ecx + edi - esi], dl
    mov byte[ecx + edi - esi + ebx], dh

    dec esi
    cmp esi, 0
    jne swap.eq
    jmp swap.e

.e:
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
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
    
