tokenize_arg1 proc
; input bx argument 1
; input di registers
; output dl status of arg1
push ax
push bx
push cx
push si
push di

cld
mov al,[bx]
cmp al,97
jl err1
cmp al,122
jg err1

inc bx
mov si,bx
mov cx,46

xd:
repne scasb
jnz vr1
cmpsb
jz ste
mov si,bx
cmp cx,0
jg xd

ste:
cmp cx,24
jle set2
jg set1

;argument 1 is variable
vr1:
mov dl,1
jmp eot1

;argument 1 is byte sized
set2:
mov dl,2
jmp eot1

;argument 1 is word sized
set1:
mov dl,3
jmp eot1

err1:
mov dl,9

eot1:
mov ah,2
int 21h

pop di
pop si
pop cx
pop bx
pop ax

ret
tokenize_arg1 endp
