.model small
.data
a db 'Thats it$'
.code
mov ax,@data
mov ds,ax
XOR bx,bx
mov ah,1
int 21h
l1:
cmp al,0dh
je l2
and al,0fh
SHL bx,1
OR bl,al
int 21h
jmp l1
l2:
mov ah,9
lea dx,a
int 21h
mov ah,4ch
int 21h
end
