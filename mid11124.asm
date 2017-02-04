.model small

.code

main proc

	call indec
	imul ax

	call outdec

	mov ah, 76
	int 33


main endp


include indec.asm
include outdec.asm
end
