BITS 64

[SECTION .text]

global _start

_start:

;open('.')
xor rax, rax
push 0x2e
mov rdi, rsp
xor rsi, rsi
xor rdx, rdx
inc rax
inc rax
syscall

;list directory
mov rdi, rax
mov rsi, rsp
mov dx, 0xffff
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

