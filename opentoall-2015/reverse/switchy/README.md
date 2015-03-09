Writeup
-------

When opening main() with IDA, we can see a repetition of pattern :

```
.text:080486E0 mov     eax, dword_804B050
.text:080486E5 mov     [esp], eax
.text:080486E8 call    sub_8048470

.text:080486ED lea     ecx, format     ; "%c"
.text:080486F3 movsx   edx, al
.text:080486F6 mov     [esp], ecx      ; format
.text:080486F9 mov     [esp+4], edx
.text:080486FD call    _printf
```

The software seems to be printing something unreadable. Since the program is so small, instinct tells us it might be the flag. sub_8048470 looks like a big switch (title of challenge) and each path depends on the parameter given to sub_8048470 and each small block contains a small xor routine and then return 1 byte that is given to _printf in main. So the program is just xoring the flag and printing us the crypted version. Following the flow of calls in the main we reconstruct the flag :

```
flag{switch jump pogo pogo bounce}
```

