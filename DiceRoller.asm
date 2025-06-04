.model small
.stack 100h
.data
    msg db 'Rolling Dice...$'
    outmsg db 0Dh, 0Ah, 'You rolled: $'
    num db ?

.code
main:
    mov ax, @data
    mov ds, ax

    lea dx, msg
    mov ah, 09h
    int 21h

    ; Get time-based seed for randomness
    mov ah, 2Ch
    int 21h     ; DL = hundredths of seconds

    ; Make it between 1–6
    mov al, dl
    and al, 00000111b  ; 0-7
    cmp al, 0
    jne not_zero
    inc al
not_zero:
    cmp al, 7
    jbe skip
    mov al, 6
skip:
    add al, '0'

    lea dx, outmsg
    mov ah, 09h
    int 21h

    mov dl, al
    mov ah, 02h
    int 21h

    mov ah, 4Ch
    int 21h
end main
