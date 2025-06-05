.model small
.stack 100h
.code
main:
    mov cx, 5

beep_loop:
    mov ah, 02h
    mov dl, 07h
    int 21h

    mov dx, 0FFFFh
delay1:
    dec dx
    jnz delay1

    loop beep_loop

    mov ah, 4ch
    int 21h
