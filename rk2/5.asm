section bss
txt resb 255

section text
global _start

_start:
    mov eax, 3
    mov ebx, 0 
    mov ecx, offset txt
    mov edx, 255

    mov ecx, 0
    mov edx, 0

cyclesearch:
    mov al, [txt + ecx]
    cmp al, ' '
    je  cyclesearch.foundnewword

.foundnewword:
    mov al, [txt + ecx + 1]
    cmp al, 'm'
    je  cyclesearch.foundword

.foundword:
    cmp edx, 0
    je  cyclesearch.fou


