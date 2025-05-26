; File: STRLEN.ASM
.model small
.stack 100h
.data
    msg db "Assembly", '$'
    len_msg db "Length is: $"
    newline db 13, 10, "$"
.code
main:
    mov ax, @data
    mov ds, ax

    ; Print "Length is: "
    lea dx, len_msg
    mov ah, 09h
    int 21h

    lea si, msg
    xor cx, cx

count_loop:
    mov al, [si]
    cmp al, '$'
    je done
    inc cx
    inc si
    jmp count_loop

done:
    mov ax, cx
    call print_num
    call new_line

    mov ah, 4Ch
    int 21h

; Reuse print_num
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
