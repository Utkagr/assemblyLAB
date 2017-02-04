    .model small
    .stack 100h
    .data
    msg DB 13,10, 'Enter $'
    str1 DB 100 dup('$')
    add_err DB 'ERROR:: Add Command syntactically incorrect !!! $'
    numerr DB 'ERROR:: Number cannot be a source !!!$'
    memerr DB 'ERROR:: both source and dest cannot be memory !!!$'
    sizeerr DB 'ERROR:: Source and dest must be of same type !!!$'
    suc DB 'Command Accepted$'
    len db ?
    strsi db 'si'
    strdi db 'di'
    strbp db 'bp'
    strsp db 'sp'
     
    .code
     
    CMPMEMVAR PROC
        Push SI
        Push DI
        Mov AH, 0
        Lea DI, strsi
        mov cx, 2
        repe cmpsb
        jnz ml1
        mov ah, 1
        pop DI
        pop SI
        RET
        ml1: pop DI
        pop SI
        Push SI
        Push DI
        lea DI, strdi
        mov cx, 2
        repe cmpsb
        jnz ml2
        mov ah, 1
        pop DI
        pop SI
        RET
        ml2: pop DI
        pop SI
        Push SI
        Push DI
        lea DI, strbp
        mov cx, 2
        repe cmpsb
        jnz ml3
        mov ah, 1
        pop DI
        pop SI
        RET
        ml3: pop DI
        pop SI
        push SI
        push DI
        lea DI, strsp
        mov cx, 2
        Repe cmpsb
        jnz ml4
        mov ah, 1
        pop DI
        pop SI
        RET
        ml4: Pop DI
        Pop SI
        RET
    CMPMEMVAR ENDP
     
    ;check for word sized register
    CHECKWR PROC
        Push SI
        Mov AH, 0
        Mov BL,97
        CMP [SI], BL
        JL EWR
        Mov BL,100
        CMP [SI], BL
        JG EWR
        Inc SI
        Mov BL,120
        Cmp [SI], BL
        JNE EWR
        Inc SI
        Mov BL,44
        Cmp [SI], BL
        JNE EWR
        Mov AH, 1
        RET
        EWR: Pop SI 
        CALL CMPMEMVAR       
        RET
    CHECKWR ENDP
     
    ; check for byte sized register
    CHECKBR PROC
        Push SI
        Mov AH, 0
        Mov BL,97
        CMP [SI], BL
        JL EBR
        Mov BL,100
        CMP [SI], BL
        JG EBR
        Inc SI
        Mov BL,104
        Cmp [SI], BL
        JE EBR2
        Mov BL,108
        Cmp [SI], BL
        JNE EBR
        EBR2: Inc SI
        Mov BL,44
        Cmp [SI], BL
        JNE EBR
        Mov AH, 2
        EBR: Pop SI
        RET
    CHECKBR ENDP
     
     ; check for memory
    CHECKMEM PROC
        Push SI
        Mov AH, 0
        Mov BL,91
        Cmp [SI], BL
        JE mm1
        Pop SI
        RET
        mm1:
        Inc SI
        CALL CMPMEMVAR
        Cmp AH, 0
        JNE mm2
        Pop SI
        RET
        mm2:
        Add SI, 2
        Mov BL,93
        Cmp [SI], BL
        JE mm3
        Mov AH, 0
        Pop SI
        RET
        mm3:
        Inc SI
        Mov BL,44
        Cmp [SI], BL
        JE mm4
        Mov AH, 0
        Pop SI
        RET
        mm4:
        Mov AH, 4
        Pop SI
        RET
    CHECKMEM ENDP
     
    CMPSTR PROC
        Push SI
        Mov AH, 0
        Call CHECKWR
        Cmp AH, 1
        JNE c1
        Pop SI
        Add SI, 3
        RET
        c1: Pop SI
        Push SI
        Call CHECKBR
        CMP AH, 2
        JNE c2
        Pop SI
        Add SI, 3
        RET
        c2: Pop SI
        Push SI
        Call CHECKMEM
        Cmp AH, 4
        JNE c3
        Pop SI
        Add SI, 5
        RET
        c3: Pop SI
        Push SI
        Call CHECKNUM
        Cmp AH, 4
        JNE c4
        Pop SI
        RET
        c4: Pop SI
        RET
    CMPSTR ENDP
     
    CHECKNUM PROC
        Mov BX, 0
        Mov CX, 0
        Mov AH, 0
        Mov DX, 0
        L:
        Mov BL, 44
        Cmp [SI], BL
        JE L1
        Mov BL, 48
        Cmp [SI], BL
        JL L2
        Mov BL, 57
        Cmp [SI], BL
        JG L2
        Add BH, 1
        Inc SI
        Jmp L
        L1:
        Cmp BH, 0
        JE L2
        Mov AH, 5
        L2:
        RET
    CHECKNUM ENDP
     
    MAIN PROC
        mov AX,@data
        mov DS,AX
        mov ES,AX
     
        lea DX,msg
        mov AH,9
        int 21h
     
        mov len,0
        lea SI,str1
        mov AH,1
     
        READ:
            int 21h
            inc len
            mov [SI],AL
            Add SI, 1
            cmp AL,13
            jnz READ

        ;mov AL, 65
        ;mov [SI],AL
     
        lea DX,str1
        mov AH,9
        int 21h
        ;jmp a_end
     
        ;mov AH,2
        ;mov DL,len
        ;int 33
     
        ; Checking if starting from ADD_
        mov BL,97
        lea SI,str1
        cmp [SI],BL
        jnz endadderr
        inc SI
        mov BL,100
        cmp [SI],BL
        jnz endadderr
        inc SI
        cmp [SI],BL
        jnz endadderr
        inc SI
        mov BL,32
        cmp [SI],BL
        jnz endadderr
     
        ;check if reg or memory or num
        inc SI
        call CMPSTR
        mov AL,AH
        ;Mov DL, AL
        ;add DL,65
        ;mov AH,2
        ;int 21h
        ;jmp a_end
     
        cmp AL,5
        jz num_err
     
        cmp AL,0
        jz endadderr
     
        call CMPSTR
     
        cmp AH,0
        jz endadderr
     
        push CX
        mov CL,3
        shl AL,CL
        add AL,AH
        pop CX
     

        cmp AL,36
        jz mem_err
     
        cmp AL,10
        jz byte_word_err
     
        cmp AL,17
        jz byte_word_err
     
        ;cmp AL, 34
        ;jz mem_byte_err
     
        ;cmp AL,20
        ;jz mem_byte_err
     
        ;cmp AL,<bsr>
        ;cmp AH, 256
        ;jl success
     
        ;cmp AL,<wsr> or <mem>
        ;cmp AH,65535
        ;jl success
     
        jmp success
     
        endadderr:
            lea DX,add_err
            mov AH,9
            int 33
            jmp a_end
     
        num_err:
            lea DX,numerr
            mov AH,9
            int 33 
            jmp a_end
     
        mem_err:
            lea DX,memerr
            mov AH,9
            int 33 
            jmp a_end
     
        byte_word_err:
            lea DX,sizeerr
            mov AH,9
            int 33 
            jmp a_end
     
        mem_byte_err:
            lea DX,sizeerr
            mov AH,9
            int 33 
            jmp a_end
     
        success:
            lea DX,suc
            mov AH,9
            int 21h
     
        a_end:
            mov AH,76
            int 21h
    MAIN ENDP
    END MAIN