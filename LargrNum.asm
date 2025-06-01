.model small
.stack 100h

.data
    a db 25
    b db 42
    max db ?

.code
main:
    mov ax, @data
    mov ds, ax

    mov al, a
    cmp al, b
    jge store_a
    mov al, b

store_a:
    mov max, al

    mov ah, 4Ch
    int 21h
end main
