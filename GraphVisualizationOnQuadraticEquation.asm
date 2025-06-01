; Enhanced Integration Visualization in Assembly
; This program creates a graphical representation of integration
; with user input and improved visuals

.model small
.stack 100h
.data
    ; Function parameters
    x_start dw -600     ; Starting x coordinate (will be updated by user input)
    x_end   dw 600      ; Ending x coordinate (will be updated by user input)
    y_scale dw 200      ; Scaling factor for y values
    
    ; Function coefficient storage (ax? + bx + c)
    coef_a dw 1        ; Default values
    coef_b dw 0
    coef_c dw 0
    
    ; Colors
    bg_color    db 0   ; Black background
    curve_color db 14  ; Yellow for the function curve
    area_color  db 9   ; Light blue for the filled area
    axis_color  db 15  ; White for axes
    grid_color  db 8   ; Dark gray for grid lines
    
    ; Messages
    title_msg db 'Integration Visualization', 0
    prompt_a db 'Enter coefficient a (for ax^2): $'
    prompt_b db 'Enter coefficient b (for bx): $'
    prompt_c db 'Enter coefficient c (constant): $'
    prompt_start db 'Enter start of integration range (-100 to 100): $'  ; New prompt for start range
    prompt_end db 'Enter end of integration range (-100 to 100): $'      ; Updated prompt for end range
    x_axis_msg db 'X', 0
    y_axis_msg db 'Y', 0
    area_msg db 'Area under curve = ', 0
    fn_msg db 'f(x) = ', 0
    
    ; Variables for calculation
    area_result dw 0    ; Store integration result
    temp_str db 6 dup('$')  ; Temporary string for number conversion
    
    ; Screen center coordinates
    center_x dw 160     ; Center x (half of 320)
    center_y dw 100     ; Center y (half of 200)
    
    ; Scale factors for screen coordinates
    x_factor dw 2       ; Pixels per unit on x-axis
    y_factor dw 1       ; Pixels per unit on y-axis
    
.code
main proc
    mov ax, @data
    mov ds, ax
    
    ; Get user input for function coefficients
    call get_user_input
    
    ; Set video mode 13h (320x200, 256 colors)
    mov ax, 0013h
    int 10h
    
    ; Clear screen with background color
    call clear_screen
    
    ; Draw grid
    call draw_grid
    
    ; Draw coordinate axes
    call draw_axes
    
    ; Draw the function based on user input
    call draw_function
    
    ; Fill the area under the curve
    call fill_area
    
    ; Calculate and display the integration result
    call calculate_area
    call display_area
    
    ; Display function equation
    call display_function
    
    ; Wait for key press
    mov ah, 0
    int 16h
    
    ; Return to text mode
    mov ax, 0003h
    int 10h
    
    ; Exit program
    mov ax, 4C00h
    int 21h
main endp

; Get user input for function coefficients
get_user_input proc
    ; Get coefficient a
    mov ah, 09h
    lea dx, prompt_a
    int 21h
    
    call read_number
    mov coef_a, ax
    
    ; New line
    mov ah, 02h
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h
    
    ; Get coefficient b
    mov ah, 09h
    lea dx, prompt_b
    int 21h
    
    call read_number
    mov coef_b, ax
    
    ; New line
    mov ah, 02h
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h
    
    ; Get coefficient c
    mov ah, 09h
    lea dx, prompt_c
    int 21h
    
    call read_number
    mov coef_c, ax
    
    ; New line
    mov ah, 02h
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h
    
    ; Get start range 
    mov ah, 09h
    lea dx, prompt_start
    int 21h
    
    call read_number
    
    ; Make sure start range is within bounds
    cmp ax, -100
    jl start_too_small
    cmp ax, 100
    jg start_too_large
    mov x_start, ax
    jmp start_ok
    
start_too_small:
    mov x_start, -100
    jmp start_ok
    
start_too_large:
    mov x_start, 100
    
start_ok:
    ; New line
    mov ah, 02h
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h
    
    ; Get end range
    mov ah, 09h
    lea dx, prompt_end
    int 21h
    
    call read_number
    
    ; Make sure end range is within bounds
    cmp ax, -100
    jl end_too_small
    cmp ax, 100
    jg end_too_large
    mov x_end, ax
    jmp end_ok
    
end_too_small:
    mov x_end, -100
    jmp end_ok
    
end_too_large:
    mov x_end, 100
    
end_ok:
    ; Make sure start is less than end
    mov ax, x_start
    cmp ax, x_end
    jle ranges_ok
    
    ; Swap start and end if needed
    mov bx, x_end
    mov x_start, bx
    mov x_end, ax
    
ranges_ok:
    ret
get_user_input endp

; Read a number from keyboard
read_number proc
    mov cx, 0       ; Digit counter
    mov bx, 0       ; Result
    mov si, 0       ; Flag for negative number
    
    read_digit:
        mov ah, 01h
        int 21h
        
        cmp al, 13  ; Check if Enter pressed
        je read_done
        
        cmp al, '-' ; Check if negative
        jne not_minus
        mov si, 1   ; Set negative flag
        jmp read_digit
        
    not_minus:
        sub al, '0' ; Convert to number
        cmp al, 9
        ja read_digit ; Skip if not a digit
        
        cbw         ; Convert byte to word (al to ax)
        
        ; Multiply bx by 10 and add new digit
        push ax
        mov ax, 10
        mul bx
        mov bx, ax
        pop ax
        
        add bx, ax
        inc cx
        
        jmp read_digit
        
    read_done:
        mov ax, bx
        ; Check if number should be negative
        cmp si, 1
        jne not_negative
        neg ax
        
    not_negative:
        ret
read_number endp

; Clear screen with background color
clear_screen proc
    mov ah, 0Ch       ; Write pixel
    mov al, bg_color  ; Background color
    mov cx, 0         ; Start x
    
    clear_y:
        mov dx, 0     ; Start y
        
        clear_x:
            int 10h   ; Write pixel
            inc dx
            cmp dx, 200
            jl clear_x
            
        inc cx
        cmp cx, 320
        jl clear_y
        
    ret
clear_screen endp

; Draw grid lines
draw_grid proc
    ; Convert logical coordinates to screen coordinates
    
    ; Draw horizontal grid lines
    mov si, -100      ; Start at -100
    
    horiz_grid:
        ; Convert y coordinate to screen coordinate
        mov ax, si
        neg ax         ; Negate because screen y is inverted
        mov bx, y_factor
        imul bx        ; Multiply by scale factor
        add ax, [center_y]  ; Add center y
        
        cmp ax, 0       ; Check if it's within screen
        jl skip_horiz
        cmp ax, 199
        jg skip_horiz
        
        mov dx, ax     ; Set y position
        mov cx, 0     ; Start x
        
        horiz_line:
            mov ah, 0Ch      ; Write pixel
            mov al, grid_color
            int 10h
            
            inc cx
            cmp cx, 320
            jl horiz_line
            
    skip_horiz:
        add si, 20    ; Move to next grid line (every 20 units)
        cmp si, 100
        jle horiz_grid
    
    ; Draw vertical grid lines
    mov si, -100      ; Start at -100
    
    vert_grid:
        ; Convert x coordinate to screen coordinate
        mov ax, si
        mov bx, x_factor
        imul bx        ; Multiply by scale factor
        add ax, [center_x]  ; Add center x
        
        cmp ax, 0       ; Check if it's within screen
        jl skip_vert
        cmp ax, 319
        jg skip_vert
        
        mov cx, ax     ; Set x position
        mov dx, 0     ; Start y
        
        vert_line:
            mov ah, 0Ch      ; Write pixel
            mov al, grid_color
            int 10h
            
            inc dx
            cmp dx, 200
            jl vert_line
            
    skip_vert:
        add si, 20    ; Move to next grid line (every 20 units)
        cmp si, 100
        jle vert_grid
        
    ret
draw_grid endp

; Draw coordinate axes
draw_axes proc
    ; Draw x-axis (horizontal)
    mov cx, 0           ; Start x
    mov dx, [center_y]  ; y position (middle of screen)
    mov al, axis_color  ; Color
    
    x_axis_loop:
        mov ah, 0Ch     ; Write pixel
        int 10h
        inc cx
        cmp cx, 320
        jl x_axis_loop
    
    ; Draw y-axis (vertical)
    mov cx, [center_x]  ; x position (center)
    mov dx, 0           ; Start y
    
    y_axis_loop:
        mov ah, 0Ch     ; Write pixel
        int 10h
        inc dx
        cmp dx, 200
        jl y_axis_loop
        
    ; Label axes
    ; X-axis label
    mov ah, 02h
    mov bh, 0
    mov dh, 12         ; Row (near center)
    mov dl, 38         ; Column (right side)
    int 10h
    
    mov si, offset x_axis_msg
    call print_string
    
    ; Y-axis label
    mov ah, 02h
    mov bh, 0
    mov dh, 3          ; Row (top)
    mov dl, 20         ; Column (near center)
    int 10h
    
    mov si, offset y_axis_msg
    call print_string
        
    ret
draw_axes endp

; Evaluate function f(x) = ax? + bx + c
; Input: cx = x value (screen)
; Output: ax = function value
evaluate_function proc
    ; Convert screen x to logical x
    mov ax, cx
    sub ax, [center_x]  ; Subtract center x
    mov bx, [x_factor]
    cwd                 ; Convert to double word for division
    idiv bx             ; ax = (cx - center_x) / x_factor
    
    ; Save logical x
    push ax
    
    ; Calculate ax?
    imul ax            ; ax = x * x
    
    ; Scale down to prevent overflow
    mov bx, 5          ; Reduced scale factor from 10 to 5 for better visualization
    cwd                ; Convert to double word for division
    idiv bx            ; ax = x?/5
    
    imul coef_a        ; ax = a*x?/5
    
    ; Save a*x? result
    push ax
    
    ; Calculate bx
    pop dx             ; Get original x (saved above)
    mov ax, dx         ; Move to ax for multiplication
    imul coef_b        ; ax = b*x
    
    ; Add a*x? + b*x
    pop dx
    add ax, dx
    
    ; Add constant c
    add ax, coef_c
    
    ; Scale result for display
    mov bx, [y_scale]
    cwd                ; Convert word to double word for division
    idiv bx            ; ax = f(x)/scale
    
    ret
evaluate_function endp

; Convert logical coordinates to screen coordinates
; Input: ax = logical x, dx = logical y
; Output: cx = screen x, dx = screen y
convert_to_screen proc
    ; Convert x
    imul word ptr [x_factor]    ; Multiply by x scale factor
    add ax, [center_x]          ; Add center x
    mov cx, ax                  ; Store screen x in cx
    
    ; Convert y (inverted)
    mov ax, dx
    neg ax                      ; Negate y (screen coordinates are inverted)
    imul word ptr [y_factor]    ; Multiply by y scale factor
    add ax, [center_y]          ; Add center y
    mov dx, ax                  ; Store screen y in dx
    
    ret
convert_to_screen endp

; Draw function f(x) = ax? + bx + c
draw_function proc
    ; Loop through each screen x pixel
    mov cx, 0             ; Start at screen x = 0
    
    function_loop:
        ; Convert screen x to logical x
        mov ax, cx
        sub ax, [center_x]
        mov bx, [x_factor]
        cwd
        idiv bx            ; ax = logical x
        
        ; Skip if outside x range
        cmp ax, [x_start]
        jl skip_point
        cmp ax, [x_end]
        jg skip_point
        
        ; Calculate f(x)
        push cx            ; Save screen x
        
        ; x^2 term
        mov bx, ax         ; bx = x
        imul bx            ; ax = x^2
        mov bx, 5          ; Scale factor
        cwd
        idiv bx            ; ax = x^2/5
        imul word ptr [coef_a]  ; ax = a*x^2/5
        mov bx, ax         ; Save a*x^2 in bx
        
        ; Linear term
        pop cx             ; Restore screen x
        push cx            ; Save it again
        mov ax, cx
        sub ax, [center_x]
        mov si, [x_factor]
        cwd
        idiv si            ; ax = logical x
        imul word ptr [coef_b]  ; ax = b*x
        
        ; Constant term and sum
        add ax, bx         ; ax = a*x^2/5 + b*x
        add ax, [coef_c]   ; ax = a*x^2/5 + b*x + c
        
        ; Scale for display
        mov bx, [y_scale]
        cwd
        idiv bx            ; ax = f(x)/scale
        
        ; Convert to screen y coordinate
        neg ax             ; Negate because screen y is inverted
        add ax, [center_y] ; Add center y to get screen y
        mov dx, ax         ; dx = screen y
        
        ; Check if point is within screen bounds
        cmp dx, 0
        jl skip_draw
        cmp dx, 199
        jg skip_draw
        
        ; Plot the point
        pop cx             ; Restore screen x
        mov al, curve_color
        mov ah, 0Ch
        int 10h
        jmp skip_point
        
    skip_draw:
        pop cx             ; Restore screen x
        
    skip_point:
        inc cx
        cmp cx, 320
        jl function_loop
        
    ret
draw_function endp

; Fill area under the curve
fill_area proc
    ; Loop through each screen x pixel
    mov cx, 0             ; Start at screen x = 0
    
    fill_loop:
        ; Convert screen x to logical x
        mov ax, cx
        sub ax, [center_x]
        mov bx, [x_factor]
        cwd
        idiv bx            ; ax = logical x
        
        ; Skip if outside x range
        cmp ax, [x_start]
        jl skip_fill
        cmp ax, [x_end]
        jg skip_fill
        
        ; Calculate f(x) using the same method as in draw_function
        push cx            ; Save screen x
        
        ; x^2 term
        mov bx, ax         ; bx = x
        imul bx            ; ax = x^2
        mov bx, 5          ; Scale factor
        cwd
        idiv bx            ; ax = x^2/5
        imul word ptr [coef_a]  ; ax = a*x^2/5
        mov bx, ax         ; Save a*x^2 in bx
        
        ; Linear term
        pop cx             ; Restore screen x
        push cx            ; Save it again
        mov ax, cx
        sub ax, [center_x]
        mov si, [x_factor]
        cwd
        idiv si            ; ax = logical x
        imul word ptr [coef_b]  ; ax = b*x
        
        ; Constant term and sum
        add ax, bx         ; ax = a*x^2/5 + b*x
        add ax, [coef_c]   ; ax = a*x^2/5 + b*x + c
        
        ; Scale for display
        mov bx, [y_scale]
        cwd
        idiv bx            ; ax = f(x)/scale
        
        ; Convert to screen y coordinate
        neg ax             ; Negate because screen y is inverted
        add ax, [center_y] ; Add center y to get screen y
        mov dx, ax         ; dx = screen y
        
        ; Ensure we don't go off screen
        cmp dx, 0
        jl adjust_top
        jmp continue_fill
        
    adjust_top:
        mov dx, 0
        
    continue_fill:
        ; Draw vertical line from curve to x-axis
        mov bx, dx      ; Save top y position
        
        vert_fill:
            cmp dx, [center_y]  ; Only fill to x-axis, not below
            jg skip_vert_fill
            
            mov al, area_color
            mov ah, 0Ch
            pop si             ; Restore screen x
            push si            ; Save it again
            mov cx, si
            int 10h
            
        skip_vert_fill:
            inc dx
            cmp dx, [center_y]
            jle vert_fill
        
        pop cx           ; Restore screen x
        
    skip_fill:
        inc cx
        cmp cx, 320
        jl fill_loop
        
    ret
fill_area endp

; Calculate the area under the curve (integration)
calculate_area proc
    ; This needs to work with the new coordinate system
    mov area_result, 0
    mov bx, 0          ; Accumulator for area
    
    ; Calculate area from x_start to x_end
    mov si, [x_start]  ; Start with logical x_start
    
    calc_loop:
        ; Calculate f(si) - function value at logical coordinate si
        mov ax, si
        mov di, ax      ; Save x in di
        
        ; Calculate ax?
        imul ax         ; ax = x * x
        mov cx, 5
        cwd
        idiv cx         ; ax = x?/5
        imul word ptr [coef_a]  ; ax = a*x?/5
        mov cx, ax      ; Save a*x? in cx
        
        ; Calculate bx
        mov ax, di      ; Restore x
        imul word ptr [coef_b]  ; ax = b*x
        
        ; Add all terms
        add ax, cx      ; ax = a*x?/5 + b*x
        add ax, [coef_c]  ; ax = a*x?/5 + b*x + c
        
        ; Skip negative values 
        cmp ax, 0
        jle skip_area
        
        ; Add to the area result (rectangle method)
        add bx, ax
        
    skip_area:
        ; Move to next x
        inc si
        cmp si, [x_end]
        jle calc_loop
    
    ; Final scaling of the result
    mov ax, bx
    mov dx, 0
    mov cx, [y_scale]
    div cx
    
    mov [area_result], ax
    ret
calculate_area endp

; Display the calculated area
display_area proc
    ; Position cursor for text
    mov ah, 02h
    mov bh, 0
    mov dh, 1         ; Row
    mov dl, 25        ; Column
    int 10h
    
    ; Display area message
    mov si, offset area_msg
    call print_string
    
    ; Convert area_result to decimal and display
    mov ax, [area_result]
    call print_number
    
    ret
display_area endp

; Display the function equation
display_function proc
    ; Position cursor for text
    mov ah, 02h
    mov bh, 0
    mov dh, 22       ; Row
    mov dl, 10        ; Column
    int 10h
    
    ; Display function message
    mov si, offset fn_msg
    call print_string
    
    ; Display a coefficient
    mov ax, [coef_a]
    call print_number
    
    ; Display x?
    mov ah, 0Eh
    mov al, 'x'
    int 10h
    mov al, '^'
    int 10h
    mov al, '2'
    int 10h
    
    ; Display + or - for b coefficient
    mov ax, [coef_b]
    cmp ax, 0
    je skip_b
    jl b_negative
    
    ; b is positive
    mov ah, 0Eh
    mov al, '+'
    int 10h
    mov ax, [coef_b]
    jmp show_b
    
b_negative:
    mov ah, 0Eh
    mov al, '-'
    int 10h
    mov ax, [coef_b]
    neg ax
    
show_b:
    call print_number
    
    ; Display x
    mov ah, 0Eh
    mov al, 'x'
    int 10h
    
skip_b:
    ; Display + or - for c coefficient
    mov ax, [coef_c]
    cmp ax, 0
    je skip_c
    jl c_negative
    
    ; c is positive
    mov ah, 0Eh
    mov al, '+'
    int 10h
    mov ax, [coef_c]
    jmp show_c
    
c_negative:
    mov ah, 0Eh
    mov al, '-'
    int 10h
    mov ax, [coef_c]
    neg ax
    
show_c:
    call print_number
    
skip_c:
    ret
display_function endp

; Utility procedure to print a string
print_string proc
    string_loop:
        mov al, [si]
        cmp al, 0
        je string_end
        
        mov ah, 0Eh     ; Teletype output
        int 10h
        inc si
        jmp string_loop
    string_end:
    ret
print_string endp

; Utility procedure to print a number
print_number proc
    ; Check if the number is negative
    test ax, ax
    jns positive_num
    
    ; Number is negative
    push ax
    mov ah, 0Eh
    mov al, '-'
    int 10h
    pop ax
    neg ax
    
positive_num:
    ; Simple procedure to print number in ax
    mov bx, 10
    mov cx, 0
    
    ; Handle the case when number is 0
    test ax, ax
    jnz convert_loop
    
    mov ah, 0Eh
    mov al, '0'
    int 10h
    jmp print_done
    
    ; Convert to digits on stack
    convert_loop:
        mov dx, 0
        div bx          ; Divide ax by 10
        push dx         ; Push remainder
        inc cx          ; Count digits
        test ax, ax     ; Check if quotient is 0
        jnz convert_loop
    
    ; Pop and print digits
    print_loop:
        pop dx
        add dl, '0'     ; Convert to ASCII
        mov ah, 0Eh
        mov al, dl
        int 10h
        loop print_loop
    
print_done:
    ret
print_number endp
????
end main
