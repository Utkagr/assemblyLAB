INDEC proc
; input: null
; output AX; number entered

	PUSH BX
	PUSH CX
	PUSH DX

inB1:
	MOV AH, 2
	MOV DL ,'?'
	INT 33

	XOR BX, BX
	XOR CX, CX

	MOV AH, 1
	INT 21H
	CMP AL, '-'
	JE inM1
	CMP AL, '+'
	JE inP1 
	JMP inR1
inM1:
	MOV CX, 1
inP1:
	INT 21H
inR1:
	CMP AL, '0'
	JNGE inN1
	CMP AL, '9'
	JG inN1
	AND AX, 000FH
	PUSH AX

	MOV AX, 10
	MUL BX
	POP BX
	ADD BX, AX

	MOV AH, 1
	INT 21H
	CMP AL, 0DH
	JNE inR1
	MOV AX, BX
	OR CX, CX
	JE inE1
	NEG AX
inE1:
	POP DX
	POP CX
	POP BX
	RET

inN1:
	MOV AH, 2
	MOV DL, 0DH
	INT 33
	MOV DL, 0AH
	INT 21H
	JMP inB1

INDEC ENDP