extern getmas
extern outi

section .data
    iarr  db  "Enter array: ", 10
    iarrl equ $-iarr
    
    iarrn  db  "#1 #2 #3 #4 "

    ot1   db  "Max sum of pozitive numbers was in stroke #"
    ot1l  equ  $-ot1
    ot2   db  " and equal "
    ot2l  equ $-ot2
    max   dd 0
    maxi  dd -1

section .bss
    arro resb 24
    arri resb 255

section .text
global _start

_start:
    mov edi, 0
    jmp getarr

getarr:
    mov  ebx, iarrn
    mov  eax, 3 
    mul  edi
    add  ebx, eax

    mov  eax, 3
    mov  ecx, arro
    mov  edx, arri
    mov  esi, 6
    
    call getmas

    mov  eax, arro
    mov  ebx, 6
    call calcsum

    cmp ecx, [max]
    jge ecxmovmax
    jmp getarre

getarre:
    add edi, 1
    cmp edi, 4
    je  exit
    jmp getarr


ecxmovmax:
    mov dword[max],  ecx
    inc edi
    mov dword[maxi], edi
    sub edi, 1
    jmp getarre

exit:   
    mov  eax, maxi
    mov  ecx, ot1
    mov  edx, ot1l
    call outi
    
    mov  eax, max 
    mov  ecx, ot2
    mov  edx, ot2l
    call outi

    mov eax, 1
    int 80h

; Процедура, которая считает сумму положительных чисел в массиве
; In:
;   eax -- ссылка на массив
;   ebx -- длина массива
; Out:
;   ecx -- вычисленная сумма
calcsum:
    push edx
    push ebx
    push eax

    mov  eax, ebx
    mov  ebx, 4
    mul  ebx
    mov  ebx, eax
    pop  eax
    push eax

    add eax, ebx
    
    mov ecx, 0


calcsuml:
    sub eax, ebx
    mov edx, [eax]
    cmp edx, 0
    jg  calcsumlsum
    jmp calcsumle

calcsumlsum:
    add ecx, edx
    jmp calcsumle

calcsumle:
    add eax, ebx

    sub ebx, 4
    cmp ebx, 0
    jne calcsuml

    jmp calcsume

calcsume:
    pop eax
    pop ebx
    pop edx
    ret
