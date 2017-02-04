.model small

.data

str1 db 80 dup('$')
str2 db 80 dup('$')

.code

main proc
	mov ax, @data
	mov ds, ax
	mov es, ax

	lea di, str1
	call read_str
	mov ax, bx
	mov si, di

	lea di, str2
	call read_str

	call strcat

	mov ah, 9
	lea dx, str2
	int 33

	mov ah, 76
	int 33


main endp

strcat proc
	; input; SI - string 1
	; DI - string 2
	; ax, bx size of string 1, string 2
	; output: SI
	
	push si
	push di
	push cx

	add di, bx
	mov cx, ax

	cld
	rep movsb

	pop cx
	pop di
	pop si
	ret
strcat endp
include readstr.asm
end