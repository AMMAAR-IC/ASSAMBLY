.model small
.stack 100h

.data
    a db 10
    b db 20
    temp db ?

.code
main:
    mov ax, @data
    mov ds, ax

    mov al, a
    mov temp, al

    mov al, b
    mov a, al

    mov al, temp
    mov b, al

    mov ah, 4Ch
    int 21h
end main
