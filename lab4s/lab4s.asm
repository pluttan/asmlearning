extern getmas
extern outi

section .data
    enterArray    db  "Enter array:", 10
    enterArrayLen equ $-enterArray
    ansArray      db  10, "Answer array:"
    ansArrayLen   equ $-ansArray


section .bss
    bufofstr resb 3
    arrout   resb 72
    arrin    resb 255

section .text
global _start

_start:
    mov eax, 4
    mov ebx, 1
    lea ecx, [enterArray]
    mov edx, enterArrayLen
    int 80h

    mov ecx, 0
    mov esi, 0
    jmp getArray

getArray:
    mov byte[bufofstr], "#"
    add ecx, "1"
    mov byte[bufofstr + 1], cl
    sub ecx, "1"
    mov byte[bufofstr + 2], " "
    
    push ecx
    push esi
    
    lea ecx, [arrout + esi]
    mov eax, 3
    lea ebx, [bufofstr]
    lea edx, [arrin]
    mov esi, 6
    call getmas
    
    pop  esi
    push esi
    add  esi, arrout
    mov  edi, 6 
    call calcmul

    mov eax, ecx

    pop  esi
    pop  ecx
    
    mov ebx, esi
    shl ecx, 2
    add ebx, ecx
    shr ecx, 2
    mov dword[arrout], 9999999

    inc  ecx
    add  esi, 24
    cmp  ecx, 3
    jne  getArray

    jmp end

end:
    call print
    mov  eax, 1
    int  80h

print:
    mov eax, 4
    mov ebx, 1
    lea ecx, [ansArray]
    mov edx, ansArrayLen
    int 80h
    mov byte[bufofstr], 10
    mov byte[bufofstr + 1], "#"
    
    mov esi, 0
    mov edi, "1"
    jmp print.loop

.loop:
    mov byte[bufofstr], 10
    mov ecx, edi
    mov byte[bufofstr + 2], cl
    
    mov eax, 4
    mov ebx, 1
    lea ecx, [bufofstr]
    mov edx, 3
    int 80h

    mov ebx, 0
    jmp print.loop2

.loop2:
    shl ebx, 2
    lea eax, [arrout + ebx + esi]
    shr ebx, 2
    mov byte[bufofstr], " "
    lea ecx, [bufofstr]
    mov edx, 1
    call outi


    inc ebx
    cmp ebx, 6
    jne print.loop2
    jmp print.loopend

.loopend:
    inc edi
    add esi, 24
    cmp esi, 72
    jne print.loop
    
    mov eax, 4
    mov ebx, 1
    lea ecx, [bufofstr]
    mov edx, 1
    int 80h

    ret

; esi ссылка edi длина ecx возврат
calcmul:
    push esi
    push edi
    push edx
    push ebx
    push eax

    mov ecx, 1

.loop:
    mov  eax, [esi]
    push eax
    cdq
    mov  ebx, 3
    idiv ebx
    pop  eax
    cmp  edx, 0
    je   calcmul.loopmul
    jmp  calcmul.loopend

.loopmul:
    imul ecx
    mov  ecx, eax
    jmp  calcmul.loopend
    
.loopend:
    add esi, 4
    dec edi
    cmp edi, 0
    jne calcmul.loop

    jmp calcmul.end

.end:
    cmp ecx, 1
    je  calcmul.ecxmin
    jmp calcmul.end2

.ecxmin:
    mov ecx, -1         ; число если не найдено
    jmp calcmul.end2
    
.end2:
    pop eax
    pop ebx
    pop edx
    pop edi
    pop esi
    ret
