.model small
.stack 100h
.code
main:
    mov dx, 0

flash:
    mov ah, 0Bh
    mov bh, 0
    mov bl, dl
    int 10h

    not dl

    mov cx, 0FFFFh
delay:
    loop delay
    jmp flash
