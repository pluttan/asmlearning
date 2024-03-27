global geti
global stoi
global ctoi
; Процедура, приглашающая пользователя на ввод, получающая строку на входе и приобразовывающая ее в число
; In:
;   eax -- количество букв в предложении
;   ebx -- ссылка на первую букву приглашения      
;   ecx -- количество цифр, которые введет пользователь
;   edx -- ссылка на память, выделенную под ввод
; Out:
;   В памяти под ввод число, которое ввел пользователь
geti:
    push eax
    push ebx
    push edx
    push ecx

    mov ecx, ebx
    mov edx, eax
    mov eax, 4      ; Пишем приглашение на ввод
    mov ebx, 1
    int 80h

    mov  eax, 3      ; Читаем ввод
    mov  ebx, 0
    pop  edx
    pop  ecx
    push ecx
    push edx
    int  80h

    mov  eax,  0
    mov  ebx, ecx
    mov  ecx, edx
    mov  edx, ebx
    call stoi
    mov  dword[ebx], eax

    pop ecx
    pop edx
    pop ebx
    pop eax

    ret
;
; Процедура, преобразующая  символ в цифру
; in:
;   dl -- символ
; out: 
;   dl -- цифра
ctoi:
    cmp dl, '0'
    jl ctoie

    cmp dl, '9'
    jg ctoie

    sub dl, '0'
    jmp ctoie
;
.ctoie:
    ret
;
; Процедура, преобразующая массив символов в число ; in:
;   dx -- адрес первого символа
;   cx -- количество символов
; out:
;   ax -- число
stoi:
    push esi
    push edx
    push ebx
    push ecx

    mov esi, edx
    mov eax, 0
    mov ebx, 10
    mov dx, 0
    
    mov dl, [esi]
    cmp dl, '-'
    je  stoiminus

    push 0
    jmp  stoil
;
.stoiminus:
    inc  esi
    push 1
    jmp  stoil
;
.stoil:
    mov dl, [esi]
    inc esi

    cmp dl, 0x0a ; =LF
    je  stoie

    call ctoi

    push dx
    mul  ebx
    mov  edx, 0
    pop  dx
    add  eax, edx

    sub ecx, 1
    cmp ecx, 0
    je stoie

    jmp stoil   
;
.stoie:
    mov ecx, 0
    pop ecx
    cmp cl, 1
    je  stoiaddm
    jmp stoiend
;
.stoiaddm:
    mov ecx, -1
    mul ecx
    jmp stoiend
;
.stoiend:
    pop ecx
    pop ebx
    pop edx
    pop esi

    ret 
