.model small
.stack 100h
.code
main:
    mov ah, 01h
    mov ch, 0Ah
    mov cl, 0Bh
    int 10h

    mov dx, 0FFFFh
delay:
    dec dx
    jnz delay
    jmp main
