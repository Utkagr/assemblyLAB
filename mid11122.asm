.model small


.code

main proc

	mov bx, 50fah
	call printHex

	mov ah, 76
	int 33


main endp

printHex proc
	; input; BX - Number to printin hexa-decimal
	; output: Nothing
	push ax
	push bx
	push cx

	mov cx, 4

redo:
	mov ax, bx
	and ax, 000fh
	cmp al, 10
	jl l1
	add ax, 'A'-10
	jmp l2
l1:
	add ax, '0'
l2:
	push ax
	
	push cx
	mov cl, 4
	shr bx, cl
	pop cx
	
	loop redo

	mov ah, 2
	mov cx, 4

redo2:
	pop dx
	int 33
	loop redo2


	pop cx
	pop bx
	pop ax

	ret
printHex endp

end