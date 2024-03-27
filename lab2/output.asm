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
    
    pop eax
    pop ecx
    pop edx
    pop ebx

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

    mov ebx, 10

    cmp eax, 0
    jl  itosminus

    jmp  itosl
;
.itosminus:
    mov  byte[esi], '-'
    
    inc  esi
    
    mov  ecx, -1
    mul  ecx

    jmp  itosl
;
.itosl:
    mov edx, 0
    div ebx
    add edx, '0'
    mov byte[esi], dl

    inc esi

    cmp eax, 0
    je  itose

    jmp itosl
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
    je reverseminus

    jmp reversel
; 
.reverseminus:
    inc ebx
    jmp reversel
;
.reversel:
    cmp ebx, edx
    jge reversee

    mov al, [ebx]
    mov cl, [edx]
    mov byte[ebx], cl
    mov byte[edx], al

    inc ebx
    sub edx, 1

    jmp reversel
;
.reversee:
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
;
