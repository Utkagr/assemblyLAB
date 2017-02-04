.model small
.code
mov ah,1
int 21h
cmp al,65
jnge l1
cmp al,90
jnle l1
mov ah,2
mov dl,al
int 21h
l1:
mov ah,76
int 21h
end
