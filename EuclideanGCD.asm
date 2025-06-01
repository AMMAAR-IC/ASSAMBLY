.model small
.stack 100h
 
.data
    a dw 48
    b dw 18
    gcd dw ?

.code
main:
    mov ax, @data
    mov ds, ax

    mov ax, a
    mov bx, b

gcd_loop:
    cmp bx, 0
    je store
    mov dx, 0
    div bx
    mov ax, bx
    mov bx, dx
    jmp gcd_loop

store:
    mov gcd, ax

    mov ah, 4Ch
    int 21h
end main
