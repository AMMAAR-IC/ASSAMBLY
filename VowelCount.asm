.model small
.stack 100h

.data
    str db 'education$', 0
    count db 0

.code
main:
    mov ax, @data
    mov ds, ax
    lea si, str

next_char:
    mov al, [si]
    cmp al, '$'
    je done
    cmp al, 'a'
    je inc_count
    cmp al, 'e'
    je inc_count
    cmp al, 'i'
    je inc_count
    cmp al, 'o'
    je inc_count
    cmp al, 'u'
    je inc_count
    jmp skip

inc_count:
    inc count

skip:
    inc si
    jmp next_char

done:
    mov ah, 4Ch
    int 21h
end main
