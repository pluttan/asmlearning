extern printf
extern exit

section .data
    hello dd "Hello,", 0
    world dd "world!", 0
    fmt   db "Output is: %s %s", 10, 0

section .text
global main

main:
    push world
    push hello
    push fmt
    call printf
    push 1
    call exit
