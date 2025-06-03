.model small
.stack 100h
.data
    msg1 db 'Enter number: $'
    msg2 db 13,10, 'Reversed: $'
    input db 5, 0, 5 dup(0)

.code
main:
    mov ax, @data
    mov ds, ax

    lea dx, msg1
    mov ah, 9
    int 21h

    lea dx, input
    mov ah, 0Ah
    int 21h

    lea dx, msg2
    mov ah, 9
    int 21h

    lea si, input+2
    call strToNum

    mov bx, 10
reverse_loop:
    xor dx, dx
    div bx
    push dx
    test ax, ax
    jnz reverse_loop

print_loop:
    pop dx
    add dl, '0'
    mov ah, 2
    int 21h
    cmp sp, 0FFFEh
    jne print_loop

    mov ah, 4Ch
    int 21h

strToNum:
    xor ax, ax
    xor bx, bx
next_digit:
    mov bl, [si]
    cmp bl, 13
    je done
    sub bl, '0'
    mov cx, ax
    mov ax, 10
    mul cx
    add ax, bx
    inc si
    jmp next_digit
done:
    ret
end main
