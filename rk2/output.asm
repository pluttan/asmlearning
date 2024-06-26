global outi
global itos
; Процедура, выводящая число
; In:
;   eax -- ссылка на память с числом (4 байт)
;   ecx -- ссылка на начало предложения, сопутствующего выводу
;   edx -- длина предложения
; Out:
;   Вывод числа
outi:
    push edi
    push ebx
    push edx
    push ecx
    push eax
    
    mov eax, 4      ; Пишем приглашение на вывод
    mov ebx, 1
    int 80h

    pop  ebx
    push ebx
    call itos

    mov  edx, ecx
    mov  ecx, ebx
    mov  eax, 4     ; Вывод
    mov  ebx, 1 
    int  80h

    mov  dword[ecx], edi

    pop eax
    pop ecx
    pop edx
    pop ebx
    pop edi
    
    ret
;
; Процедура, преобразующая число в массив символов
; in:
;   ebx -- адрес числа, первого символа
; out:
;   ebx -- адрес первого символа
;   ecx -- количество символов
itos:
    push esi
    push eax
    push ebx
    push ecx
    push edx

    mov esi, ebx
    mov eax, [esi]
    mov edi, eax

    mov ebx, 10

    cmp eax, 0
    jl  itos.itosminus

    jmp  itos.itosl
;
.itosminus:
    mov  byte[esi], '-'
    
    inc  esi
    
    mov  ecx, -1
    mul  ecx

    jmp  itos.itosl
;
.itosl:
    mov edx, 0
    div ebx
    add edx, '0'
    mov byte[esi], dl

    inc esi

    cmp eax, 0
    je  itos.itose

    jmp itos.itosl
;
.itose:
    pop edx
    pop ecx
    pop ebx

    mov  eax, ebx

    mov ecx, esi
    sub ecx, ebx

    call reverse    

    pop eax
    pop esi 

    ret
;
; Процедура перемещает цифры меджу друг другом
; in:
;   eax -- число
;   ecx -- количество цифр
; out:
;   eax -- перевернутое число
reverse:
    push eax
    push ebx
    push ecx
    push edx

    mov ebx, eax
    add eax, ecx
    sub eax, 1
    mov edx, eax
   
    mov al, [ebx]
    cmp al, '-'
    je reverse.reverseminus

    jmp reverse.reversel
; 
.reverseminus:
    inc ebx
    jmp reverse.reversel
;
.reversel:
    cmp ebx, edx
    jge reverse.reversee

    mov al, [ebx]
    mov cl, [edx]
    mov byte[ebx], cl
    mov byte[edx], al

    inc ebx
    sub edx, 1

    jmp reverse.reversel
;
.reversee:
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
;
