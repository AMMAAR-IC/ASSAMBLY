.model small
.stack 100h
.data
    welcomeMsg db 'Welcome to Ammaar Program!',13,10,'$'
    inputPrompt db 'Enter a string (max 50 chars): $'
    goodbyeMsg db 13,10,'Goodbye from Ammaar Program!$'
    inputBuffer db 51
    inputStr db 51 dup('$')
    upperStr db 51 dup('$')
    reverseStr db 51 dup('$')
    asciiMsg db 13,10,'ASCII values of characters:$'
    newline db 13,10,'$'

.code
main:
    mov ax, @data
    mov ds, ax

    mov ah, 09h
    lea dx, welcomeMsg
    int 21h

    mov ah, 09h
    lea dx, newline
    int 21h
    lea dx, inputPrompt
    int 21h

    mov ah, 0Ah
    lea dx, inputBuffer
    int 21h

    mov si, offset inputBuffer + 2
    mov di, offset inputStr
    mov cl, [inputBuffer+1]
    xor ch, ch
copy_loop:
    mov al, [si]
    mov [di], al
    inc si
    inc di
    loop copy_loop
    mov byte ptr [di], '$'

    lea si, inputStr
    lea di, upperStr
convert_upper:
    lodsb
    cmp al, '$'
    je done_upper
    cmp al, 'a'
    jb not_lower
    cmp al, 'z'
    ja not_lower
    sub al, 32
not_lower:
    stosb
    jmp convert_upper
done_upper:
    mov al, '$'
    stosb

    lea si, inputStr
    xor cx, cx
count_len:
    lodsb
    cmp al, '$'
    je len_found
    inc cx
    jmp count_len
len_found:
    lea si, inputStr
    add si, cx
    dec si
    lea di, reverseStr
rev_loop:
    mov al, [si]
    mov [di], al
    inc di
    dec si
    loop rev_loop
    mov byte ptr [di], '$'

    mov ah, 09h
    lea dx, newline
    int 21h
    mov ah, 09h
    lea dx, upperStr
    int 21h

    mov ah, 09h
    lea dx, newline
    int 21h
    mov ah, 09h
    lea dx, reverseStr
    int 21h

    mov ah, 09h
    lea dx, newline
    int 21h
    lea dx, asciiMsg
    int 21h

    lea si, inputStr
ascii_loop:
    lodsb
    cmp al, '$'
    je done_ascii
    call print_ascii
    jmp ascii_loop
done_ascii:

    mov ah, 09h
    lea dx, newline
    int 21h
    lea dx, goodbyeMsg
    int 21h

    mov ah, 4Ch
    int 21h

print_ascii proc
    push ax
    push bx
    push cx
    push dx

    mov ah, 0
    mov bl, 10
    xor cx, cx
print_loop:
    xor dx, dx
    div bl
    push dx
    inc cx
    test ax, ax
    jnz print_loop

print_digits:
    pop dx
    add dl, '0'
    mov ah, 02h
    int 21h
    loop print_digits

    mov dl, ' '
    mov ah, 02h
    int 21h

    pop dx
    pop cx
    pop bx
    pop ax
    ret
print_ascii endp

end main
