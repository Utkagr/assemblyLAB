.model small
.code
xor bx,bx
mov cl,4
mov ah,1
int 21h
w1:
cmp al,0dh
je e1
cmp al,29h
jg le1
and al,0fh
jmp s1
le1:
sub al,37h
s1:
shl bx,cl
or bl,al
int 21h
jmp w1
e1:
mov ah,76
int 21h
end
