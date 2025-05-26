; File: ARMSTRNG.ASM
.model small
.stack 100h
.data
    num dw 153
    result_msg db "Is an Armstrong number$"
    fail_msg db "Is NOT an Armstrong number$"
    newline db 13, 10, "$"
.code
main:
    mov ax, @data
    mov ds, ax

    mov ax, num
    mov cx, ax        ; store original number
    xor dx, dx

    ; Extract digits and cube them
    xor si, si        ; sum = 0

next_digit:
    mov bx, 10
    xor dx, dx
    div bx
    mov bx, dx        ; digit in BX
    mov dx, bx
    mul bx            ; AX = digit^2
    mul dx            ; AX = digit^3
    add si, ax
    test ax, ax
    cmp cx, 0
    jne next_digit

    ; Compare sum with original
    cmp si, cx
    jne not_armstrong

    lea dx, result_msg
    jmp print_msg

not_armstrong:
    lea dx, fail_msg

print_msg:
    mov ah, 09h
    int 21h

    call new_line

    mov ah, 4Ch
    int 21h

new_line:
    lea dx, newline
    mov ah, 09h
    int 21h
    ret
end main
