.model small
.stack 100h
.data
    msg1 db 'Enter first digit (0-9): $'
    msg2 db 13,10,'Enter second digit (0-9): $'
    msg3 db 13,10,'Choose operation (+, -, *, /): $'
    resultMsg db 13,10,'Result: $'
    goodbyeMsg db 13,10,'Thank you for using AmmaarCalc8086!$'
    newline db 13,10,'$'

.code
main:
    mov ax, @data
    mov ds, ax

    mov ah, 09h
    lea dx, msg1
    int 21h
    mov ah, 01h
    int 21h
    sub al, '0'
    mov bl, al

    mov ah, 09h
    lea dx, msg2
    int 21h
    mov ah, 01h
    int 21h
    sub al, '0'
    mov bh, al

    mov ah, 09h
    lea dx, msg3
    int 21h
    mov ah, 01h
    int 21h
    mov cl, al

    mov al, bl
    mov dl, bh

    cmp cl, '+'
    je add_op
    cmp cl, '-'
    je sub_op
    cmp cl, '*'
    je mul_op
    cmp cl, '/'
    je div_op
    jmp exit

add_op:
    add al, dl
    jmp display

sub_op:
    sub al, dl
    jmp display

mul_op:
    mul dl
    jmp display

div_op:
    cmp dl, 0
    je div_zero
    xor ah, ah
    div dl
    jmp display

div_zero:
    mov ah, 09h
    lea dx, newline
    int 21h
    mov dx, offset newline
    int 21h
    mov dx, offset goodbyeMsg
    int 21h
    mov ah, 4Ch
    int 21h

display:
    add al, '0'
    mov ah, 09h
    lea dx, resultMsg
    int 21h

    mov dl, al
    mov ah, 02h
    int 21h

exit:
    mov ah, 09h
    lea dx, newline
    int 21h
    lea dx, goodbyeMsg
    int 21h

    mov ah, 4Ch
    int 21h

end main
