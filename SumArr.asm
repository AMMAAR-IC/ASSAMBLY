.model small
.stack 100h

.data
    array db 5, 10, 15, 20, 25
    length db 5
    sum dw 0

.code
main:
    mov ax, @data
    mov ds, ax
    xor cx, cx
    xor ax, ax
    lea si, array
    mov cl, length

next:
    mov bl, [si]
    add al, bl
    inc si
    loop next

    mov sum, ax

    mov ah, 4ch
    int 21h
end main
