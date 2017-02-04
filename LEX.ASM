lexer proc
; input di offset address
; input bx number of characters
; output di starting address of normalized string
push ax
push cx
push di

mov cx,bx
norm:
mov al,[di]
cmp al,65
jl noalph
cmp al,90
jg noalph
add al,32
mov [di],al
noalph:
inc di
loop norm

pop di

leadspace:
mov al,[di]
inc di
cmp al,20h
je leadspace

;starting address stored here in si
dec di

pop cx
pop ax
ret
lexer endp
