.model small
.stack 100h

.data
    num dw 1234
    rev dw 0

.code
main:
    mov ax, @data
    mov ds, ax

    mov cx, num
    xor dx, dx

next:
    mov ax, cx
    xor dx, dx
    mov bx, 10
    div bx
    mov cx, ax
    mov ax, rev
    mov bx, 10
    mul bx
    add ax, dx
    mov rev, ax
    cmp cx, 0
    jne next

    mov ah, 4Ch
    int 21h
end main
