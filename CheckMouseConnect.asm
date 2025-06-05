.model small
.stack 100h
.data
    msg_yes db 'Mouse Found$'
    msg_no  db 'No Mouse$'

.code
main:
    mov ax, @data
    mov ds, ax

    mov ax, 0
    int 33h
    cmp ax, 0
    je no_mouse

    mov ah, 09h
    lea dx, msg_yes
    int 21h
    jmp exit

no_mouse:
    mov ah, 09h
    lea dx, msg_no
    int 21h

exit:
    mov ah, 4ch
    int 21h
