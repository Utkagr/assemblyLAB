tokenize_arg2 proc
; input bx offset address arg2
; input di offset registers
; output dl status of arg2

push ax
push bx
push cx
push si
push di

mov al,[bx]
cmp al,48
jl err2
cmp al,122
jg err2
cmp al,58
jl arg2num
cmp al,97
jl err2
cmp al,'?'
jl err2

inc bx
mov si,bx
mov cx,46

xd2:
repne scasb
jnz vr2
cmpsb
jz ste2
mov si,bx
cmp cx,0
jg xd2

ste2:
cmp cx,24
jle set4
jg set3

;argument 2 is variable
vr2:
mov dl,1
jmp eot2

;argument 2 is byte sized
set4:
mov dl,2
jmp eot2

;argument 2 is word sized
set3:
mov dl,3
jmp eot2

arg2num:
mov dl,4
jmp eot2

err2:
mov dl,9

eot2:
mov ah,2
int 21h

pop di
pop si
pop cx
pop bx
pop ax

ret
tokenize_arg2 endp
