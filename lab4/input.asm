global getmas
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


; Процедура, приглашающая пользователя на ввод, получающая строку на входе и приобразовывающая ее в массив чисел
; In:
;   eax -- количество букв в предложении
;   ebx -- ссылка на первую букву приглашения      
;   ecx -- ссылка на массив
;   edx -- ссылка на память, выделенную под ввод
;   esi -- количество чисел
; Out:
;   В памяти под ввод число, которое ввел пользователь

getmas:
    push esi
    push edi
    push eax
    push ebx
    push ecx
    push edx
    
    mov ecx, ebx
    mov edx, eax
    mov eax, 4      ; Пишем приглашение на ввод
    mov ebx, 1
    int 80h

    mov  eax, 3      ; Читаем ввод
    mov  ebx, 0
    pop  ecx
    pop  edx
    push ecx
    push edx
    mov  edx, 255 
    int  80h

    mov  edx, ecx
    pop  ecx
    push ecx

    mov  edi, esi
    mov  eax, edi
    mov  edi, 4
    push edx
    mul  edi
    pop  edx
    mov  edi, eax
    mov  eax, 0

    add  ecx, edi
    mov  ebx, 0


getmasl:
    call stoi
    sub  ecx, edi
    mov  dword[ecx], eax
    add  ecx, edi
    mov  edx, esi
    
    sub  edi, 4 
    cmp  edi, 0
    jne  getmasl
    jmp  getmase


getmase:
    pop ecx
    pop edx
    pop ebx
    pop eax
    pop edi
    pop esi

    ret



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

ctoie:
    ret

; Процедура, преобразующая массив символов в число ; in:
;   edx -- адрес первого символа
; out:
;   eax -- число
;   esi -- адрес выхода
stoi:
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

stoiminus:
    inc  esi
    push 1
    jmp  stoil

stoil:
    mov dl, [esi]
    inc esi

    cmp dl, 0x0a ; =LF
    je  stoie
    cmp dl, ' ' 
    je  stoie

    call ctoi

    push dx
    mul  ebx
    mov  edx, 0
    pop  dx
    add  eax, edx

    jmp stoil

stoie:
    mov ecx, 0
    pop ecx
    cmp cl, 1
    je  stoiaddm
    jmp stoiend

stoiaddm:
    mov ecx, -1
    mul ecx

stoiend:
    pop ecx
    pop ebx
    pop edx

    ret
 
