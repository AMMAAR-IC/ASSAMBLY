.model small
.stack 100h

.data
    num db 3
    cube dw ?

.code
main:
    mov ax, @data
    mov ds, ax

    mov al, num
    mov ah, 0
    mov bl, al
    mul bl
    mov bl, al
    mul bl
    mov cube, ax

    mov ah, 4Ch
    int 21h
end main
