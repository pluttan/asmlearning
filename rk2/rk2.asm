extern outi

section .data
    
    ;   4   2   72  3   1   4   2   2
    ;   100 5   25  625 25  5   1   10
    ;   99  50  26  35  7   14  100 100
    matrix dd 4, 2, 72, 3, 1, 4, 2, 2,   100, 5, 25, 625, 25, 5, 1, 10,     99, 50, 26, 35, 7, 14, 100, 100

    strokematrix    db "Cтрока матрицы "
    lenstrokematrix equ $-strokematrix

    outsymv db "#:/="

    st    db "Stroke #"
    lenstr equ $-st

    ndstr    db " and #"
    lenndstr equ $-ndstr

    areeq    db " are equal", 10
    lenareeq equ $-areeq

section .bss

    buf resd 4
    sysbuf resd 1

section .text
global _start

_start:
    mov esi, 0
    jmp cycle

cycle:
    call printstroke
    mov ecx, 0
    jmp cycle2

cycle2:
    shl  ecx, 2
    mov  edi, esi
    shl  edi, 5
    add  ecx, edi
    shl  edi, 1
    add  edi, 28

    mov eax, dword[matrix + ecx]
    
    neg  ecx
    add  ecx, edi
    mov  ebx, dword[matrix + ecx]
    cmp  ebx, 0         ; Обработка деления на 0, не обязательно
    je   exitwitherror  ; 
    sub  ecx, edi
    neg  ecx

    cdq
    idiv ebx
    sub  edi, 28
    shr  edi, 1
    sub  ecx, edi
    mov  dword[buf + ecx], eax
    push ecx
    shr  ecx, 2
    inc  ecx

    mov  dword[sysbuf], ecx
    lea  eax, [sysbuf]
    mov  edx, 1
    push ecx
    lea  ecx, [outsymv]
    call outi
    
    lea  ecx, [outsymv+1]
    call outi

    mov  edx, 8
    pop  ecx
    sub  edx, ecx
    push ecx
    inc  edx
    mov  dword[sysbuf], edx
    lea  ecx, [outsymv + 2]
    mov  edx, 1
    call outi

    pop  ecx
    pop  edx
    sub  ecx, 1
    push ecx
    lea  eax, [buf + edx]
    lea  ecx, [outsymv + 3]
    mov  edx, 1
    call outi
    call print10
    
    pop ecx
    inc ecx
    cmp ecx, 4
    je  cycle2.end

    jmp cycle2

.end:
    mov  ecx, 0
    jmp  cycle2.cycleeq

.cycleeq:
    mov  eax, ecx
    shl  eax, 2
    mov  eax, dword[buf + eax]
    mov  edx, 0
    jmp  cycle2.cycleeq2

.cycleeq2:
    cmp edx, ecx
    jg  cycle2.cycleeqtrue
    inc edx
    cmp edx, 4
    je  cycle2.cycleeq2end
    jmp cycle2.cycleeq2

.cycleeqtrue:
    shl edx, 2
    mov ebx, dword[buf + edx]
    shr edx, 2

    cmp eax, ebx
    je  cycle2.cycleeqprint
    
    inc edx
    cmp edx, 4
    je  cycle2.cycleeq2end

    jmp cycle2.cycleeq2

.cycleeqprint:
    push eax
    push ecx
    push edx

    inc  ecx ; Для одинаковой нумерации строк
    mov  dword[sysbuf], ecx
    lea  eax, [sysbuf]
    lea  ecx, [st]
    mov  edx, lenstr
    call outi

    pop  ecx
    push ecx
    inc  ecx ; Для одинаковой нумерации строк
    mov  dword[sysbuf], ecx
    lea  ecx, [ndstr]
    mov  edx, lenndstr
    call outi

    mov eax, 4
    mov ebx, 1
    lea ecx, [areeq]
    mov edx, lenareeq
    int 80h

    pop edx
    pop ecx
    pop eax
    
    inc edx
    cmp edx, 4
    je  cycle2.cycleeq2end

    jmp cycle2.cycleeq2

.cycleeq2end:
    inc ecx
    cmp ecx, 4 ;cmp ecx, 3 is eq
    je  cycle2.cycleeqend
    jmp cycle2.cycleeq

.cycleeqend:
    inc esi
    cmp esi, 3
    je  endprog
    jmp cycle

endprog:
    mov eax, 1
    mov ebx, 0
    int 80h

printstroke:
    inc  esi ; для более красивого вывода, не обязательно
    mov  dword[sysbuf], esi
    dec  esi ; для более красивого вывода, не обязательно
    lea  eax, [sysbuf]
    lea  ecx, [strokematrix]
    mov  edx, lenstrokematrix
    call outi
    
    call print10
    
    ret

print10:
    push eax
    push ebx
    push ecx
    push edx

    mov byte[sysbuf], 10
    lea ecx, [sysbuf]
    mov eax, 4
    mov ebx, 1
    mov edx, 1
    int 80h

    pop edx
    pop ecx
    pop ebx
    pop eax

    ret

exitwitherror: ; Обработка исключения: деление на 0, не обязательно
    mov dword[buf],   "ERR:" 
    mov dword[buf+4], "div "
    mov byte[buf+8], "0"
    mov byte[buf+9], 10
    mov eax, 4
    mov ebx, 1
    lea ecx, [buf]
    mov edx, 12
    int 80h

    mov eax, 1 ; Выход с ошибкой 1
    int 80h
