.model small
.stack 100h
.data
    ball db 'O'
    clear db ' '

.code
main:
    mov ax, @data
    mov ds, ax

    mov cx, 10     ; number of bounces
next_bounce:
    ; move forward
    mov si, 1
move_right:
    mov dl, si
    mov dh, 10     ; row
    call print_ball
    call delay

    ; clear previous
    mov dl, si
    mov dh, 10
    call clear_ball

    inc si
    cmp si, 70
    jne move_right

    ; move backward
    dec si
move_left:
    mov dl, si
    mov dh, 10
    call print_ball
    call delay
    call clear_ball
    dec si
    cmp si, 1
    jne move_left

    loop next_bounce

    mov ah, 4Ch
    int 21h

;-------------------------------
print_ball:
    mov ah, 02h
    mov bh, 0
    int 10h        ; move cursor
    mov ah, 0Eh
    mov al, 'O'
    int 10h
    ret

clear_ball:
    mov ah, 02h
    mov bh, 0
    int 10h
    mov ah, 0Eh
    mov al, ' '
    int 10h
    ret

delay:
    mov cx, 0FFFF
d1: loop d1
    ret
end main
