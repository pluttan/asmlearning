; "The pattern ", 34
; 34, " occurs "
; " times in the line", 10
section .data
    pat1 db "abc abc cab"
    pat2 db "ab cab"

section .bss
    buf resb 255

section .text
global _start

_start:
    mov  rsi, pat1
    mov  rdx, pat2
    mov  r10, buf
    call fif

    mov  rax, 4
    mov  rbx, 1
    lea  rcx, [buf]
    mov  rdx, 255

    mov rax, 1
    int 80h

; берем 1 букву пробегаем по всему pat2 если нашли такую букву берем вторую и чекаем есть ли совпадение если совпадение есть, то берем букву дальше и так далее пока совпадения не будет, если адреса разные то кидаем это как ответ. Ответ организовывается в виде 2 чисел: начало в первой строке и длина

fif: 
    push rdi
    push rsi
    push rdx
    push rcx
    push rbx
    push rax
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    
    mov rax, rsi

    push rsi
    mov  rsi, rdx
    call len
    mov  r9, r8

    pop  rsi
    call len

    mov r11, 0

    cmp r8, 0
    je  fif.strlen0

    cmp r9, 0
    je  fif.strlen0

    mov rcx, 0
    jmp fif.loop1

.strlen0:
    jmp fif.end

.loop1:
    mov rbx, 0
    jmp fif.loop2

.loop2:
    mov r12, [rsi + rcx]
    mov r13, [rdx + rbx]
    cmp r12, r13
    je  fif.findfirstchar
    jmp fif.loop2e

.findfirstchar:
    mov rdi, rcx
    mov rax, rbx
    jmp fif.loop3b1

.loop3b1:
    cmp rdi, r8
    jl  fif.loop3b2
    jmp fif.loop3e

.loop3b2:
    cmp rax, r9
    jl  fif.loop3b3
    jmp fif.loop3e

.loop3b3:
    mov r12, [rsi + rdi]
    mov r13, [rdx + rax]
    cmp r12, r13
    je  fif.loop3b4
    jmp fif.loop3e

.loop3b4:
    cmp r12, " "
    jne fif.loop3
    jmp fif.loop3e

.loop3:
    inc rdi
    inc rax
    jmp fif.loop3b1

.loop3e:
    jmp fif.cmprdircx

.cmprdircx:
    push rdi
    sub  rdi, rcx
    cmp  rdi, 1
    pop  rdi
    jg   fif.findpat
    jmp  fif.loop2e

.findpat:
    push rcx
    jmp fif.loop4

.loop4:
    mov r12, [rsi + rcx]
    mov [r10 + r11], r12
    inc r11
    inc rcx
    cmp rdi, rcx
    jg  fif.loop4
    jmp fif.findpate

.findpate: 
    pop rcx
    mov [r10 + r11], 10
    inc r11
    jmp fif.loop2e

.loop2e:
    inc rbx
    cmp rbx, r9
    jl  fif.loop2
    jmp fif.loop1e

.loop1e:
    inc rcx
    cmp rcx, r8
    jl  fif.loop1
    jmp fif.end

.end:
    pop r13   
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rax
    pop rbx
    pop rcx
    pop rdx
    pop rsi
    pop rdi
    ret   
    

; rsi -- begin
; r8 -- res
len:
    push rax
    mov  r8, 0
    jmp  len.l

.l:
    mov al, [rsi + r8]
    cmp al, 0
    je  end
    inc r8
    jmp len.l

.e:
    pop rax
    ret
    

