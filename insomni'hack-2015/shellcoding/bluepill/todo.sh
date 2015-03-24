#!/bin/sh

nasm -f elf64 -o shellcode.o shellcode.asm && ld -s shellcode.o -o shellcode
for i in $(objdump -d shellcode | grep "^ " | cut -f2); do echo -n '\x'$i; done; echo
