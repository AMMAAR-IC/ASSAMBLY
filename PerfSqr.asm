.model small
.stack 100h

.data
    num dw 49
    result db 0

.code
main:
    mov ax, @data
    mov ds, ax

    mov ax, 1
    mov bx, num

check_loop:
    mov dx, ax
    mul dx
    cmp ax, bx
    je square
    cmp ax, bx
    ja done
    inc dx
    mov ax, dx
    jmp check_loop

square:
    mov result, 1

done:
    mov ah, 4Ch
    int 21h
end main
