.model small
.stack 100h

.data
    str db 'banana$', 0
    ch db 'a'
    count db 0

.code
main:
    mov ax, @data
    mov ds, ax

    lea si, str

next_char:
    mov al, [si]
    cmp al, '$'
    je done
    cmp al, ch
    jne skip
    inc count

skip:
    inc si
    jmp next_char

done:
    mov ah, 4Ch
    int 21h
end main
