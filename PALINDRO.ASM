.model small
.data
a db 'eatae'
b db '$'
c db 'Not a palindrome.$'
d db 'A palindrome.$'
.code
mov ax,@data
mov ds,ax
lea si,a
lea di,a
l1:
cmp [si],'$'
je k1
mov si,si+1
jmp l1
k1:
mov di,si-1
lea si,a

l2:
cmp [si],[di]
jne l3
mov si,si+1
mov di,di-1
jmp l2

l3:
mov ah,9
lea dx,c
int 21h
end