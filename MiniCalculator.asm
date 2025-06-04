.model small
.stack 100h
.data
    msg1 db 'Enter first digit: $'
    msg2 db 0Dh,0Ah,'Enter operator (+ - * /): $'
    msg3 db 0Dh,0Ah,'Enter second digit: $'
    msg4 db 0Dh,0Ah,'Result: $'

.code
main:
    mov ax, @data
    mov ds, ax

    ; First number
    lea dx, msg1
    mov ah, 09h
    int 21h

    mov ah, 01h
    int 21h
    sub al, '0'
    mov bl, al

    ; Operator
    lea dx, msg2
    mov ah, 09h
    int 21h

    mov ah, 01h
    int 21h
    mov bh, al

    ; Second number
    lea dx, msg3
    mov ah, 09h
    int 21h

    mov ah, 01h
    int 21h
    sub al, '0'
    mov cl, al

    ; Perform Operation
    cmp bh, '+'
    je add_op
    cmp bh, '-'
    je sub_op
    cmp bh, '*'
    je mul_op
    cmp bh, '/'
    je div_op
    jmp exit

add_op:
    mov al, bl
    add al, cl
    jmp display

sub_op:
    mov al, bl
    sub al, cl
    jmp display

mul_op:
    mov al, bl
    mul cl
    jmp display

div_op:
    mov ax, 0
    mov al, bl
    div cl
    jmp display

display:
    add al, '0'
    lea dx, msg4
    mov ah, 09h
    int 21h

    mov dl, al
    mov ah, 02h
    int 21h

exit:
    mov ah, 4Ch
    int 21h
end main
