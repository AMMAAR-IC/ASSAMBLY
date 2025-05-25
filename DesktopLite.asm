.model small
.stack 100h
.data
menu db 13,10,"--- Arduino UNO Basic Desktop ---",13,10
     db "1. Show Welcome Message",13,10
     db "2. Show Fake Time",13,10
     db "3. Exit",13,10,"Select Option (1-3): $"

msg1 db 13,10,"Hello! Welcome to Arduino Desktop!",13,10,"$"
msg2 db 13,10,"Time: 12:34:56 (Fake)",13,10,"$"
exitmsg db 13,10,"Exiting...$" 

.code
main:
    mov ax, @data
    mov ds, ax

menu_start:
    lea dx, menu
    mov ah, 09h
    int 21h

    mov ah, 01h    
    int 21h
    cmp al, '1'
    je option1
    cmp al, '2'
    je option2
    cmp al, '3'
    je option3
    jmp menu_start

option1:
    lea dx, msg1
    mov ah, 09h
    int 21h
    jmp menu_start

option2:
    lea dx, msg2
    mov ah, 09h
    int 21h
    jmp menu_start

option3:
    lea dx, exitmsg
    mov ah, 09h
    int 21h
    mov ah, 4Ch
    int 21h
end main
