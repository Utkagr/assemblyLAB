; Name: UTKARSH AGRAWAL
; Roll No. : 13MA20044
; System's Assignment
; Question: Check the validity of an add statement.
; Input: Add ax,bx
; Output: CORRECT SYNTAX

.MODEL SMALL
    .DATA
   	 INST  DB  0DH,0AH, ' INPUT THE STRING :  $'
   	 INST2 DB  0DH,0AH, ' YOUR STRING IS > :  $'
   	 FIRSTTOKEN DB 'add'
   	 STRING1 DB  255 DUP(?)
   	 ERR DB 0DH, 0AH,'INCORRECT SYNTAX.$'
   	 NOERR DB 0DH, 0AH, 'CORRECT SYNTAX$'
   	 ;FLAG_WORD DB ?
   	 FLAG_NUMBER DB ?
   	 FLAG_REGISTER DB ?
   	 REG8 DB 'al','bl','cl','dl','ah','bh','ch','dh'
    	REG16 DB 'ax','bx','cx','dx'
   	 REGMEM DB 'si', 'di', 'sp', 'bp'
    .CODE


STOP PROC
    MOV AH, 9
    LEA DX, ERR
    INT 33
    MOV AH, 76
    INT 33
STOP ENDP


NERR PROC
    PUSH AX
    PUSH DX
    MOV AH, 9
    LEA DX, NOERR
    INT 33
    POP DX
    POP AX
NERR ENDP




TOKEN_LEN PROC
    ; Output: Length of string in CX


    PUSH SI
    PUSH AX
    XOR CX, CX
    NEXT:
   	 MOV AL, [SI]
   	 CMP AL, 32
   	 JZ LEN
   	 CMP AL, ','
   	 JZ LEN
   	 CMP AL, '$'
   	 JZ LEN
   	 INC CX
   	 INC SI
   	 JMP NEXT


    LEN:
   	 ;Mov AH, 2
   	 ;Mov DL, CL
   	 ;Add DL, 48
   	 ;Int 33
   	 POP AX
   	 POP SI
   	 RET


TOKEN_LEN ENDP

NUMBER PROC
   	   ; String's current address in SI
   	   ; CX contains length of string in SI

   	   PUSH AX
   	   PUSH CX
   	   PUSH SI

    LEA DI, FLAG_NUMBER
    PARSE:
   	   MOV AL, [SI]
   	   CMP AL, 48
   	   JL NOTNUMBER
   	   CMP AL, 57
   	   JG NOTNUMBER
   	   INC SI
   	   LOOP PARSE

      POP SI
      POP CX
      POP AX
      Mov [DI], BYTE PTR 1
      RET

    NOTNUMBER:
   	 Mov [DI], BYTE PTR 0
   	 POP SI
     	 POP CX
     	 POP AX
   	 RET
NUMBER ENDP

INLIST PROC
    ; SETS BX TO 1 IF LIST POINTED BY DI CONTAINS [SI, SI+1]
    ; CX CONTAINS LENGTH OF LIST POINTED BY DI
    PUSH AX
    PUSH CX
    MOV BX, 0

   	 MOV AL, [SI]
   	 MOV AH, [SI + 1]
    COMPARE:
   	 CMP AL, [DI]
   	 JNE INC2
   	 CMP AH, [DI + 1]
   	 JE DONE
   	 INC2:
   		 ADD DI, 2
   	 LOOP COMPARE

   	 JMP RETURN
   	 DONE:
   		 MOV BX, 1
    RETURN:
   	 POP CX   		 
   	 POP AX
   	 RET
INLIST ENDP

MEMORY PROC
   	 PUSH AX
   	 PUSH CX
   	 PUSH BX

   	 MOV AL, [SI + 3]
   	 CMP AL, ']'
   	 JNE SYNTAXERROR

   	 LEA DI, REGMEM
   	 MOV CX, 4
   	 INC SI
   	 CALL INLIST
   	 CMP BX, 0
   	 JE SYNTAXERROR

   	 ADD SI, 3

   	 POP BX
   	 POP CX
   	 POP AX
   	 RET


   	SYNTAXERROR:
   		 CALL STOP


MEMORY ENDP


REGISTER PROC
   	 PUSH DI
   	 PUSH CX
   	 PUSH BX


   	 LEA DI, REG8
   	 MOV CX, 8
   	 CALL INLIST


   	 CMP BX, 1
   	 JE  RETURN_REG


   	 LEA DI, REG16
   	 MOV CX, 4
   	 CALL INLIST


   	 CMP BX, 1
   	 JE  RETURN_REG


   	 JMP NOTREG   	 


   	 NOTREG: JMP ERRORSYNTAX ; NOT A NUMBER, NOT MEMORY, NOT A REGISTER


   	 RETURN_REG:
   		 ADD SI, 2
   		 POP BX
   		 POP CX
   		 POP DI
   		 RET


   	 ERRORSYNTAX:
   		 CALL STOP
REGISTER ENDP


REGISTER2 PROC
   	 PUSH DI
   	 PUSH CX
   	 PUSH BX
   	 PUSH AX


   	 LEA DI, REG8
   	 MOV CX, 8
   	 CALL INLIST


   	 CMP BX, 1
   	 JE RETURN_REG2


   	 LEA DI, REG16
   	 MOV CX, 4
   	 CALL INLIST


   	 CMP BX, 1
   	 JE RETURN_REG2


   	 JMP NOTREG2   	 


   	 NOTREG2:
   		 CALL STOP


   	 RETURN_REG2:
   		 ADD SI, 2
   		 POP AX
   		 POP BX
   		 POP CX
   		 POP DI
   		 RET
REGISTER2 ENDP

TOKEN1 PROC
   	   ; String's current address in SI

   	   PUSH AX
   	   PUSH CX

   	   CALL TOKEN_LEN
   	   CALL NUMBER
   	   MOV AL, FLAG_NUMBER
   	   CMP AL, 1
   	   JZ CALL_STOP
   	   ; NOT A NUMBER, CHECK FOR REGISTERS/MEMORY


   	   MOV AL, [SI]
   	   CMP AL, '['
   	   JNE CHECKREG
   	   CALL MEMORY
   	   JMP RETURN_TOKEN1


   	   CHECKREG: CALL REGISTER


   	   RETURN_TOKEN1:
   	  	 
   	  	 POP CX
   	  	 POP AX
   	  	 RET


   	   CALL_STOP:
   	  	 CALL STOP
TOKEN1 ENDP


TOKEN2 PROC
   	   ; String's current address in SI




   	   PUSH AX


   	   CALL TOKEN_LEN
   	   CALL NUMBER


   	   MOV AL, FLAG_NUMBER
   	   CMP AL, 1
   	   JZ IS_NUMBER
   	   ; NOT A NUMBER, CHECK FOR REGISTERS/MEMORY


   	   MOV AL, [SI]
   	   CMP AL, '['
   	   JNE CHECKREG2
   	 	 CALL MEMORY
   	   JMP RETURN_TOKEN2


   	   CHECKREG2:
   	  	 CALL REGISTER2
   	  	 JMP RETURN_TOKEN2


   	   IS_NUMBER:
   	  	 ADD SI, CX
   	  	 JMP RETURN_TOKEN2


   	   RETURN_TOKEN2:
   	  	 
   	  	 POP AX
   	  	 RET


   	   ERROR_SYNTAX:
   	  	 CALL STOP
TOKEN2 ENDP
    
CHECKSPACE PROC
   	   ; String's current address in SI
   	   ; Output - SI points to the position of first occurence of non-space cha
   	   PUSH AX
      READ_SPACE:

   	   MOV AL,[SI]
   	   CMP AL, 32
   	   JNE NON_SPACE_FOUND

   	   INC SI
   	   JMP READ_SPACE

      NON_SPACE_FOUND:

   	   POP AX
   	   RET

CHECKSPACE ENDP

COMMA PROC
   	 PUSH AX

   	 MOV AL, [SI]
   	 CMP AL, ','
   	 JE RETURN_COMMA

   	 CALL STOP

   	 RETURN_COMMA:
   	 INC SI
   	 POP AX

   	 RET
COMMA ENDP

CHECKADD PROC
    MOV CX, 3
    LEA DI, FIRSTTOKEN
    REP CMPSB
    Mov AH, 2
    JZ L


    CALL STOP
    L:
   	 RET
CHECKADD ENDP




    MAIN PROC
   	 MOV AX, @DATA
   	 MOV DS, AX
   	 MOV ES, AX




   	 LEA DX, INST
   	 MOV AH, 9
   	 INT 33
   	 LEA SI, STRING1
   	 MOV AH, 1
    INPUT:
   	 INT 33
   	 MOV BL, AL
   	 CMP AL, 0DH
   	 JE  PROCESS
   	 ;Check for Uppercase




   	 CMP AL, 65
   	 JL NOT_UPPER
   	 CMP AL, 90
   	 JG NOT_UPPER
   	 ;convert to lower
   	 ADD AL, 32
    NOT_UPPER:
   	 MOV [SI], AL
   	 INC SI
   	 JMP INPUT




    PROCESS:




   	 MOV AL, '$'
   	 MOV [SI], AL




   	 LEA SI, STRING1

     ;The code below shows the main flow of the program
     ;Check space -> Check 'add' ->Check space ->Check token1 ->Check space ->Check comma -> Check space ->
     ; Check token2 -> Check space

   	 CALL CHECKSPACE
   	 CALL CHECKADD
   	 CALL CHECKSPACE
   	 CALL TOKEN1
   	 CALL CHECKSPACE
   	 CALL COMMA
   	 CALL CHECKSPACE
   	 CALL TOKEN2
   	 CALL CHECKSPACE
   	 
   DISPLAY:




   	 LEA DX, INST2
   	 MOV AH, 9
   	 INT 33




   	 LEA DX, STRING1
   	 INT 33




   	 CALL NERR


    Mov AH, 76
    Int 33
MAIN ENDP




END MAIN


