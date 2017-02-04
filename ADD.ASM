.model small
.stack 100h
.data
msg1 db "Enter the statement as ADD -- --[dollar prompt] i.e, line should end with dollar promt$"
msg2 db "enter no commas in the code and all the registers should be in capital letters, Input:     $"

msg_correct db "the syntax is correct$"
msg_wrong db "the syntax is wrong$"

input dw 10 dup(0)
compare dw 275,276,277,278,279,280,281,282,283,284,285,286,287,288,306,307,308,309,310,311,312

.code
mov ax, @data
mov ds,ax
mov es,ax
mov ah,9
lea dx,msg1
int 33
lea dx,msg2
int 33
lea si,input

mov ah,1
level_input: int 33
mov ah,0
mov input[si],ax
inc si
cmp al,36
mov ah,1
JNE level_input

mov bx,0

mov si,4
mov ax,input[si]
add bx,ax

inc si
mov ax,input[si]
add bx,ax

inc si
inc si
mov ax,input[si]
add bx,ax

inc si
mov ax,input[si]
add bx,ax
mov ah,2
mov dx,bx
int 33
cmp bx,275
jge level_one
jl level_exit

level_one:
cmp bx,312
jle level_two
jg level_exit

mov ax,bx
mov cx,23
lea di,compare

level_two:
scasw
jz level_correct
inc di
loop level_two

mov ah,9
lea dx,msg_wrong
int 33
jmp level_exit

level_correct:
mov ah,9
lea dx,msg_correct
int 33

level_exit:
mov ah,76
int 33
end

