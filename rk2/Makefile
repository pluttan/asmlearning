.PHONY: all run clear
all:
	@nasm -f elf -o output.o output.asm
	@nasm -f elf -o rk2.o rk2.asm
	@ld -m elf_i386 -o rk2 rk2.o output.o
	@echo "compiled successfully"
run:
	@./rk2
clear:
	@rm rk2 rk2.o output.o
