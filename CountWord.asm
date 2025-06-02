.model small
.stack 100h

.data
    str db 'I am Ammaar $', 0
    word_count db 0
    flag db 0

.code
main:
    mov ax, @data
    mov ds, ax

    lea si, str

next_char:
    mov al, [si]
    cmp al, '$'
    je done
    cmp al, ' '
    je clear_flag
    cmp flag, 0
    jne skip
    inc word_count
    mov flag, 1
    jmp skip

clear_flag:
    mov flag, 0

skip:
    inc si
    jmp next_char

done:
    mov ah, 4Ch
    int 21h
end main
