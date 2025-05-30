.model small
.stack 100h

.data
    arr db 15, 22, 3, 89, 45
    len db 5
    max db 0

.code
main:
    mov ax, @data
    mov ds, ax

    lea si, arr
    mov cl, len
    mov al, [si]
    mov max, al
    dec cl
    inc si

next:
    mov al, [si]
    cmp al, max
    jbe skip
    mov max, al

skip:
    inc si
    dec cl
    jnz next

    mov ah, 4Ch
    int 21h
end main
