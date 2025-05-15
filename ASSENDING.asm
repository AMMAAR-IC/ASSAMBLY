assume cs:code
assume ds:data

data segment
arr DB 20h,10h,50h,30h,00h
data ends 

code segment
start:MOV AX,DATA
      MOV DS,AX
      MOV AX,0000H

      MOV CL,04H
OUTER:MOV BL,04H
      LEA SI,ARR
INNER:MOV AL,[SI]
      MOV AH,[SI+1]
      CMP AL,AH
      JNS ED
      JMP UP
   ED:XCHG AL,AH
      MOV [SI],AL
      MOV [SI+1],AH
   UP:INC SI
      CMP BL,00H
      DEC BL
      JNE INNER
      LOOP OUTER
      INT 03H
CODE ENDS 
END START
