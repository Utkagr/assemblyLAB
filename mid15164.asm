.model small

.code

main proc
	
	mov ah,	 1
	xor bx,bx
	mov cx, 4

redo:
	int 33
	shl bx, 1
	shl bx, 1
	shl bx, 1
	and al, 0fh
	add bl, al

	loop redo


	mov ah, 2
	mov dl, 0ah
	int 33
	mov dl, 0dh
	int 33

	mov ax, bx
	call outdec

	mov ah, 76
	int 33
main endp
include outdec.asm

end
