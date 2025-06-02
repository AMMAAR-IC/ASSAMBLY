.model small
.stack 100h

.data
    ch db ?

.code
main:
    mov ax, @data
    mov ds, ax

    mov ah, 1
    int 21h
    mov ch, al

    mov ah, 4Ch
    int 21h
end main
