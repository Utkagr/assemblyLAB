.model small
.stack 100h
.data
cmd db 20 dup('?'), '$'
arg1 db 20 dup('?'), '$'
arg2 db 20 dup('?'), '$'
defn db "add "
wb_reg db "ax bx cx dx sp bp si di ah al bh bl ch cl dh dl"
inv_msg db "Invalid syntax!$"
val_msg db "Valid syntax!$"

.code

main proc
mov ax,@data
mov ds,ax
mov es,ax

lea di,cmd
call read_str
call lexer

push di

; checking token add
lea si,defn
mov cx,4
cld
repe cmpsb
jnz err

; copying arg1
pop di
push di
lea si,arg1
add di,4
cp1:
mov al,[di]
cmp al,2ch
je ar2
mov [si],al
inc si
inc di
jmp cp1

; copying arg2
ar2:
inc di
lea si,arg2
cp2:
mov al,[di]
cmp al,'?'
je fin
mov [si],al
inc si
inc di
jmp cp2

fin:
pop di

lea bx,arg1
lea di,wb_reg
call tokenize_arg1
mov al,dl

lea bx,arg2
lea di,wb_reg
call tokenize_arg2


cmp al,9
je err
cmp dl,9
je err

cmp dl,4
je acc

cmp al,1
jne check2
cmp dl,2
jge acc
jmp err

check2:
cmp dl,1
je acc

cmp al,dl
je acc
jmp err

acc:
lea dx,val_msg
jmp eoc       

err:
lea dx,inv_msg

eoc:
mov ah,9
int 21h

mov ah,76
int 21h
main endp
include /home/utkarsh/8086/READ.ASM
include /home/utkarsh/8086/LEX.ASM
include /home/utkarsh/8086/TARG1.ASM
include /home/utkarsh/8086/TARG2.ASM
end main
                       
