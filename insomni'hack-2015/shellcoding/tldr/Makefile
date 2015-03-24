all:
	gcc -m64 tldr.c -o tldr 

clean:
	rm -f vuln shellcode shellcode.o

shellcode:
	nasm -f elf64 -o shellcode.o shellcode.asm && ld -s shellcode.o -o shellcode
