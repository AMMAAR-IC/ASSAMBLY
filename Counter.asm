.model small
.stack 100h
.data
    msg db 13,10,'Timer: $'

.code
main:
    mov ax, @data
    mov ds, ax

    lea dx, msg
    mov ah, 9
    int 21h

    mov cx, 60

loop_start:
    push cx
    mov ax, 60
    sub ax, cx
    call print2Digit
    call delay
    pop cx
    loop loop_start

    mov ah, 4Ch
    int 21h

print2Digit:
    mov bx, 10
    xor dx, dx
    div bx
    add al, '0'
    mov ah, 2
    mov dl, al
    int 21h
    add ah, '0'
    mov dl, ah
    int 21h
    mov dl, ' '
    int 21h
    ret

delay:
    mov cx, 0FFFFh
d1:
    nop
    loop d1
    ret

end main
