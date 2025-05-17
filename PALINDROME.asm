ASSUME DS:DATA
ASSUME CS:CODE

DATA SEGMENT
    SSTRING DB "AMMAA$", 0
    DSTRING DB 30 DUP (?)
    YES DB "PALINDROME$"
    NO DB "NOT A PALINDROME$"
DATA ENDS

CODE SEGMENT
START:
    MOV AX, DATA
    MOV DS, AX

    ; Initialize pointers
    LEA SI, SSTRING
    LEA DI, DSTRING

    ; Find the length of the string
    MOV CX, 0
FIND_LENGTH:
    MOV AL, [SI + CX]
    CMP AL, '$'
    JE LENGTH_FOUND
    INC CX
    JMP FIND_LENGTH

LENGTH_FOUND:
    MOV BX, CX          ; BX = length of the string
    DEC BX              ; Adjust for 0-based index

    ; Reverse the string
    LEA SI, SSTRING
    LEA DI, DSTRING
REVERSE_LOOP:
    MOV AL, [SI + BX]
    MOV [DI], AL
    INC DI
    DEC BX
    CMP BX, -1
    JG REVERSE_LOOP

    ; Null-terminate the reversed string
    MOV BYTE PTR [DI], '$'

    ; Compare original and reversed strings
    LEA SI, SSTRING
    LEA DI, DSTRING
COMPARE_LOOP:
    MOV AL, [SI]
    CMP AL, '$'
    JE IS_PALINDROME
    MOV BL, [DI]
    CMP AL, BL
    JNE NOT_PALINDROME
    INC SI
    INC DI
    JMP COMPARE_LOOP

IS_PALINDROME:
    LEA DX, YES
    JMP DISPLAY_RESULT

NOT_PALINDROME:
    LEA DX, NO

DISPLAY_RESULT:
    MOV AH, 09H
    INT 21H

    ; Terminate program
    MOV AH, 4CH
    INT 21H
CODE ENDS
END START
