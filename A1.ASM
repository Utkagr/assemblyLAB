.model small
.data
a db 100 dup(?)
.code
mov ax,@data
mov ds,ax
lea si,a
mov ah,1
int 33
sub al,30h
mov ah,0
mov cx,ax
mov dx,ax
mov ah,1
l1:
int 33
mov [si],al
inc si
loop l1
mov cx,dx
mov ah,2
l2:
dec si
mov dl,[si]
int 33
loop l2
mov ah,76
int 33
end
