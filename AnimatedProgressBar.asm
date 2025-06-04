.model small
.stack 100h
.data
    bar db '[                    ]$'
    pos db 1
    msg db 0Dh,0Ah,'Loading...$'

.code
main:
    mov ax, @data
    mov ds, ax

    lea dx, msg
    mov ah, 09h
    int 21h

    mov cx, 20

next_step:
    ; update bar
    mov si, offset bar
    add si, pos
    mov byte ptr [si], '#'
    
    lea dx, bar
    mov ah, 09h
    int 21h

    ; delay
    mov cx, 0FFFF
delay:
    loop delay

    ; backspace to redraw
    mov dl, 13
    mov ah, 02h
    int 21h

    inc pos
    cmp pos, 21
    jne next_step

    ; done
    mov ah, 4Ch
    int 21h
end main
