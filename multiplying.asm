.model small
.data
num1 db 10h
num2 db 20h
res db ?

.code 
start:mov ax,@data
      mov ds,ax
      mov ax,0000h
      
      mov al,num1
      mov bl,num2
      mul bl
      mov res,al
end start
