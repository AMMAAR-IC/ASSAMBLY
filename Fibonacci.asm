; File: FIBO.ASM
.model small
.stack 100h
.data
    msg db "Fibonacci Series: $"
    newline db 13, 10, "$"
.code
main:
    mov ax, @data
    mov ds, ax

    ; Print message
    lea dx, msg
    mov ah, 09h
    int 21h

    mov cx, 10       ; number of terms
    mov ax, 0        ; first term
    mov bx, 1        ; second term

next_term:
    call print_num
    call new_line

    add ax, bx
    xchg ax, bx
    loop next_term

    mov ah, 4Ch
    int 21h

; Print AX as number
print_num:
    push ax
    push bx
    push cx
    push dx

    mov cx, 0
    mov bx, 10
next_digit:
    xor dx, dx
    div bx
    push dx
    inc cx
    test ax, ax
    jnz next_digit

print_digits:
    pop dx
    add dl, '0'
    mov ah, 02h
    int 21h
    loop print_digits

    pop dx
    pop cx
    pop bx
    pop ax
    ret

new_line:
    lea dx, newline
    mov ah, 09h
    int 21h
    ret
end main
