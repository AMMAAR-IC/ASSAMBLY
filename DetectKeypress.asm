.model small
.stack 100h
.code
main:
    mov ah, 01h
    int 21h

    mov ah, 02h
    mov dl, al
    int 21h

    mov ah, 4ch
    int 21h
