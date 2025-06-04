.model small
.stack 100h
.data
    msg1 db 'Enter password: $'
    correct db 'secret$'
    input db 20 dup('$')
    success db 0Dh,0Ah,'Access Granted$'
    fail db 0Dh,0Ah,'Access Denied$'

.code
main:
    mov ax, @data
    mov ds, ax

    lea dx, msg1
    mov ah, 09h
    int 21h

    lea dx, input
    mov ah, 0Ah
    int 21h

    mov si, offset input + 2
    mov di, offset correct
check:
    mov al, [si]
    mov bl, [di]
    cmp bl, '$'
    je done
    cmp al, bl
    jne wrong
    inc si
    inc di
    jmp check

done:
    lea dx, success
    mov ah, 09h
    int 21h
    jmp exit

wrong:
    lea dx, fail
    mov ah, 09h
    int 21h

exit:
    mov ah, 4Ch
    int 21h
end main
