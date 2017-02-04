.model small
.code
MOV AH,2
MOV BL,5
JMP L2
L1:MOV DL,65
MOV BL,DL
INT 33
MOV AH,76
INT 33
L2:
MOV CS:[9],byte ptr 0
JMP L1
END
