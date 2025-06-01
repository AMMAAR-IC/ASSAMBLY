.model small
.stack 100h

.data
    a db 9
    b db 4
    c db 7
    min db ?

.code
main:
    mov ax, @data
    mov ds, ax

    mov al, a
    cmp al, b
    jle skip1
    mov al, b
skip1:
    cmp al, c
    jle skip2
    mov al, c
skip2:
    mov min, al

    mov ah, 4Ch
    int 21h
end main
