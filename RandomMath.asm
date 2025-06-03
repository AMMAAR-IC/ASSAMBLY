.model small
.stack 100h
.data
    msg1 db 'Solve: $'
    msg2 db 13,10, 'Correct!$'
    msg3 db 13,10, 'Wrong!$'
    msg4 db 13,10, 'Your answer: $'
    input db 5, 0, 5 dup(0)
    ans dw ?
    num1 dw ?
    num2 dw ?
    op db ?

.code
main:
    mov ax, @data
    mov ds, ax

start:
    call randomize
    call get_random
    mov num1, ax

    call randomize
    call get_random
    mov num2, ax

    call randomize
    call get_op
    mov op, al

    lea dx, msg1
    mov ah, 9
    int 21h

    mov ax, num1
    call printNum

    mov dl, ' '
    mov ah, 2
    int 21h

    mov dl, op
    mov ah, 2
    int 21h

    mov dl, ' '
    mov ah, 2
    int 21h

    mov ax, num2
    call printNum

    lea dx, msg4
    mov ah, 9
    int 21h

    lea dx, input
    mov ah, 0Ah
    int 21h

    lea si, input+2
    call strToNum
    mov bx, ax

    mov ax, num1
    mov dx, 0

    mov al, op
    cmp al, '+'
    je do_add
    cmp al, '-'
    je do_sub
    cmp al, '*'
    je do_mul

do_add:
    add ax, num2
    jmp check

do_sub:
    sub ax, num2
    jmp check

do_mul:
    mul num2

check:
    cmp ax, bx
    je correct
    lea dx, msg3
    mov ah, 9
    int 21h
    jmp quit

correct:
    lea dx, msg2
    mov ah, 9
    int 21h

quit:
    mov ah, 4Ch
    int 21h

get_random:
    mov ah, 2Ch
    int 21h
    xor ax, ax
    mov al, dl
    xor dx, dx
    mov bx, 9
    div bx
    inc ah
    mov ax, ah
    ret

get_op:
    mov ah, 2Ch
    int 21h
    mov al, dl
    and al, 3
    cmp al, 0
    je op_plus
    cmp al, 1
    je op_minus
    cmp al, 2
    je op_mul
    mov al, '+'
    ret

op_plus:
    mov al, '+'
    ret

op_minus:
    mov al, '-'
    ret

op_mul:
    mov al, '*'
    ret

strToNum:
    xor ax, ax
    xor bx, bx
conv_loop:
    mov bl, [si]
    cmp bl, 13
    je conv_done
    sub bl, '0'
    mov cx, ax
    mov ax, 10
    mul cx
    add ax, bx
    inc si
    jmp conv_loop
conv_done:
    ret

printNum:
    mov bx, 10
    xor cx, cx
print_loop:
    xor dx, dx
    div bx
    push dx
    inc cx
    test ax, ax
    jnz print_loop
print_pop:
    pop dx
    add dl, '0'
    mov ah, 2
    int 21h
    loop print_pop
    ret

randomize:
    mov ah, 2Ch
    int 21h
    ret

end main
