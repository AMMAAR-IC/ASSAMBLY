.model small
.stack 100h
.data
    msg1 db 'Guess a number between 1 and 9: $'
    correct db 13,10, 'Correct! You guessed it.$'
    wrong db 13,10, 'Wrong. Try again.$'
    again db 13,10, 'Play again? (y/n): $'
    input db 5, 0, 5 dup(0)

.code
main:
    mov ax, @data
    mov ds, ax

start_game:
    call randomize
    call get_random

guess_loop:
    lea dx, msg1
    mov ah, 9
    int 21h

    lea dx, input
    mov ah, 0Ah
    int 21h

    lea si, input+2
    call strToNum

    cmp al, bl
    je got_it

    lea dx, wrong
    mov ah, 9
    int 21h
    jmp guess_loop

got_it:
    lea dx, correct
    mov ah, 9
    int 21h

    lea dx, again
    mov ah, 9
    int 21h

    mov ah, 1
    int 21h
    cmp al, 'y'
    je start_game

exit:
    mov ah, 4Ch
    int 21h

get_random:
    mov ah, 2Ch
    int 21h
    xor ax, ax
    mov al, dl
    xor dx, dx
    mov bl, 9
    div bl
    inc ah
    mov bl, ah
    ret

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

randomize:
    mov ah, 2Ch
    int 21h
    ret

end main
