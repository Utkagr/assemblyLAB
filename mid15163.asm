.model small

.data

prompt db 'Enter Username:$'
value db 'SYSTEM'
input db 10 dup('$')
yes db 0dh, 0ah, 'The user name is valid$'
no db 0dh, 0ah, 'Invalid user name$'

.code

main proc
		
	mov ax, @data
	mov ds, ax
	mov es, ax
	cld

	mov ah, 9
	lea dx, prompt
	int 33

	lea di, input
	call read_str
	cmp bx, 6
	jne e2

	mov cx, bx
	lea si, value

	repe cmpsb
	je e1

e2:
	lea dx, no
	jmp print

e1:
	lea dx, yes

print:
	mov ah, 9
	int 33

	mov ah, 76
	int 33

main endp
include readstr.asm

end
