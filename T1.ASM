.model small
.data
table1 db 30h,31h,32h,33h
.code
mov ax,@data
mov ds,ax
mov al,03h
lea bx,table1
XLAT
mov dl,al
mov ah,2
int 21h
mov ah,76
int 21h
end
