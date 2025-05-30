.model small
.stack 100h

.data
    msg     db 'Enter a lowercase string: $'
    str     db 20 dup(?)             
    result  db 20 dup('$')          
    newline db 13, 10, '$'

.code
main:
    mov ax, @data
    mov ds, ax
    mov es, ax
   
    lea dx, msg
    mov ah, 09h
    int 21h

    lea dx, str
    mov ah, 0Ah                      
    mov dx, offset buffer_struct
    int 21h

    lea si, buffer+2                
    lea di, result

convert_loop:
    mov al, [si]
    cmp al, 13                      
    je done

    cmp al, 'a'
    jb skip_convert
    cmp al, 'z'
    ja skip_convert
    sub al, 32                
skip_convert:
    mov [di], al
    inc si
    inc di
    jmp convert_loop

done:
    lea dx, newline
    mov ah, 09h
    int 21h

    lea dx, result
    mov ah, 09h
    int 21h

    mov ah, 4Ch
    int 21h
   
buffer_struct:
    db 20        
    db ?          
buffer:
    db 20 dup(?)  

end main
