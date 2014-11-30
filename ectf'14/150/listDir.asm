;Dirty shellcode to list directory upon exit

BITS 32
global _start

section .text
_start:
jmp get_eip

run:
xor eax, eax
xor edi, edi
inc edi
inc edi
inc edi
inc edi

add eax, edi
inc eax
pop ebx
xor ecx, ecx
xor edx, edx
int 0x80 ; open(".", 0, 0)

test eax, eax
jz error

mov ebx, eax
xor edx, edx
add edx, 1
shl edx, 8
sub esp, edx
mov ecx, esp
xor eax, eax
add eax, 1
shl eax, 7
add eax, 13
int 0x80 ; sys_getdents(fd, buffer, size)

mov edx, eax ;size
mov ecx, esp
xor ebx, ebx
add bl, 1
mov eax, edi
int 0x80 ; write(1, buf, size)

error:
    xor eax, eax
    inc eax
    xor ebx, ebx
    int 0x80 ;sys_exit

get_eip:
    call run

filename:
    db '.', 0x0
