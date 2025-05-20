ASSUME CS:CODE
ASSUME DS:DATA

DATA SEGMENT
    NUM DB 07H                        
    YES DB "NUMBER IS PRIME$"
    NO DB "NUMBER IS NOT PRIME$"
DATA ENDS

CODE SEGMENT
START:
    MOV AX, DATA
    MOV DS, AX

    MOV AL, NUM                       
    MOV BL, 02H                       
    MOV DL, 0                         

CHECK_LOOP:
    CMP BL, AL                        
    JGE END_CHECK

    MOV AH, 0                         
    MOV CL, AL
    DIV BL                            

    CMP AH, 0                         
    JNZ CONTINUE
    MOV DL, 1                         
    JMP END_CHECK

CONTINUE:
    INC BL
    JMP CHECK_LOOP

END_CHECK:
    CMP DL, 0
    JZ PRINT_YES                      
    LEA DX, NO
    JMP PRINT_MSG

PRINT_YES:
    LEA DX, YES

PRINT_MSG:
    MOV AH, 09H
    INT 21H

    MOV AH, 4CH                       
    INT 21H

CODE ENDS
END START
