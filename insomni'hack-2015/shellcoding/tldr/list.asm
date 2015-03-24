BITS 64

[SECTION .text]

global _start

_start:

xor rdi, rdi
xor rdx, rdx
mov dl, -100
mov rdi, rdx
push 0x2f
mov rsi, rsp
xor rdx, rdx
xor r10, r10
xor rax, rax
add ax, 257
syscall

mov rdi, rax
mov rsi, rsp
mov dx, 0xffff
xor rax, rax
mov al, 78
syscall

;write(1, rsp, 0xffff)
xor rdi, rdi
inc rdi
mov rsi, rsp
mov dx, 0xffff 
xor rax, rax
inc rax
syscall

