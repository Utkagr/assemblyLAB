read_str proc
;input di offset address
;output di starting address of string
;output bx number of characters

push ax
push di
cld
xor bx,bx
mov ah,1
int 21h
red1:
cmp al,0dh
je rede1
cmp al,08h
jne rede2
dec di
dec bx
jmp redr1
rede2:
stosb
inc bx
redr1:
int 21h
jmp red1
rede1:
pop di
pop ax
ret
read_str endp
