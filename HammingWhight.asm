.model small
.stack 100h
.data
    number dw 0F37h
    count  db 0
    msg    db 'Number of 1s in binary: $'

.code
main:
    mov ax, @data
    mov ds, ax

    mov cx, 16
    mov ax, number
    mov bl, 0

count_loop:
    test ax, 1
    jz skip_inc
    inc bl

skip_inc:
    shr ax, 1
    loop count_loop

    mov ah, 09h
    lea dx, msg
    int 21h

    mov ah, 0
    mov al, bl
    call PrintDecimal

    mov ah, 4ch
    int 21h

PrintDecimal proc
    push ax
    push bx
    push cx
    push dx

    xor cx, cx
    mov bx, 10

convert:
    xor dx, dx
    div bx
    push dx
    inc cx
    test ax, ax
    jnz convert

print_loop:
    pop dx
    add dl, '0'
    mov ah, 02h
    int 21h
    loop print_loop

    pop dx
    pop cx
    pop bx
    pop ax
    ret
PrintDecimal endp
