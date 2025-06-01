.model small
.stack 100h

.data
    num dw 123456
    sum db 0

.code
main:
    mov ax, @data
    mov ds, ax

    mov cx, num

loop_digits:
    xor dx, dx
    mov ax, cx
    mov bx, 10
    div bx
    mov cx, ax
    mov al, dl
    and al, 1
    jnz skip
    add sum, dl

skip:
    cmp cx, 0
    jne loop_digits

    mov ah, 4Ch
    int 21h
end main
