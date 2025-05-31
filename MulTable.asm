.model small
.stack 100h

.data
    num db 5
    res db 10 dup(?)

.code
main:
    mov ax, @data
    mov ds, ax

    mov bl, num
    xor cx, cx
    lea si, res

next:
    inc cx
    mov al, bl
    mul cl
    mov [si], al
    inc si
    cmp cx, 10
    jne next

    mov ah, 4Ch
    int 21h
end main
