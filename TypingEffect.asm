.model small
.stack 100h
.data
    text db 'I am Batman...$'

.code
main:
    mov ax, @data
    mov ds, ax

    lea si, text

next_char:
    lodsb
    cmp al, '$'
    je done
    mov ah, 02h
    mov dl, al
    int 21h

    mov cx, 0FFFFh
delay:
    loop delay

    jmp next_char

done:
    mov ah, 4ch
    int 21h
