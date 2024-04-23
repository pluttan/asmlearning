global _ZN10MainWindow3fifEPcS0_S0_
extern _ZN10MainWindow5printEPci

_ZN10MainWindow3fifEPcS0_S0_:
    jmp fif

fif: 
    push rsi
    push rdx
    push rcx
    push rbx
    push rax
    push r8
    push r9
    push r10
    push r11
    push rdi
    mov r10, rcx ; потому что на слайдах ГС было по другому
    
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
    push rax
    mov  al, [rsi + rcx]
    mov  ah, [rdx + rbx]
    cmp  al, ah
    pop  rax
    je   fif.findfirstchar
    jmp  fif.loop2e

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
    push rbx
    mov  bl, [rsi + rdi]
    mov  bh, [rdx + rax]
    cmp  bl, bh
    je   fif.loop3b4
    jmp  fif.loop3b3e

.loop3b3e:
    pop rbx
    jmp fif.loop3e

.loop3b4:
    cmp bh, " "
    pop rbx
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
    push rax
    mov  al, [rsi + rcx]
    mov  byte[r10 + r11], al
    pop  rax
    inc  r11
    inc  rcx
    cmp  rdi, rcx
    jg   fif.loop4
    jmp  fif.findpate

.findpate: 
    pop rcx
    mov byte[r10 + r11], 10
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
    pop rdi
    mov rsi, r10
    mov rdx, r11
    call _ZN10MainWindow5printEPci

    pop r11
    pop r10
    pop r9
    pop r8
    pop rax
    pop rbx
    pop rcx
    pop rdx
    pop rsi

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
    je  len.e
    inc r8
    jmp len.l

.e:
    pop rax
    ret
    

