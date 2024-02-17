section .data
    num DQ 0x100000000

section .text
global _start

_start:
    mov eax, 0b0110
    mov ebx, 0b1100
    
    and eax, ebx            ; eax = 0b0100 (0x4)

    or  eax, ebx            ; eax = 0b1100 (0xc)

    not eax                 ; eax : 0x0000000c -> 0xfffffff3 (f-c=3)
    and eax, 0xf            ; mask  0xfffffff3 -> 0x00000003 -> 0b0011

    xor eax, ebx            ; eax = 0b1111 (0xf)

    mov eax, 1
    int 80h


