section .data
    Xval dd 5          ; Value of Xval
    Yval dd 10         ; Value of Yval
    Zval dd 3          ; Value of Zval
    newline db 0x0A    ; Newline character for cleaner output
    msg_error db "Error: Division by zero", 0x0A
    len_error equ $ - msg_error
    msg_negative db '-', 0

section .bss
    buffer resb 16     ; Buffer to store the result as a string

section .text
    global _start

_start:
    ; -------------------------------
    ; Rval = -Xval + (Yval - Zval)
    ; -------------------------------

    ; Calculate -Xval
    mov eax, [Xval]    ; EAX ← Xval
    neg eax            ; EAX ← -Xval

    ; Calculate (Yval - Zval)
    mov ebx, [Yval]    ; EBX ← Yval
    sub ebx, [Zval]    ; EBX ← Yval - Zval

    ; Add the two results: -Xval + (Yval - Zval)
    add eax, ebx       ; EAX ← -Xval + (Yval - Zval)

    ; Convert EAX (Rval) to string
    call convert       ; Convert EAX to ASCII
    call print         ; Print result to console

    ; -------------------------------
    ; Rval = (Xval + Yval) * Zval
    ; -------------------------------

    ; Calculate Xval + Yval
    mov eax, [Xval]    ; EAX ← Xval
    add eax, [Yval]    ; EAX ← Xval + Yval

    ; Multiply by Zval
    imul eax, [Zval]   ; EAX ← (Xval + Yval) * Zval

    call convert 
    call print

    ; -------------------------------
    ; Rval = (Xval * -5) / (Yval % Zval)
    ; -------------------------------

    ; Calculate Xval * -5
    mov eax, [Xval]    ; EAX ← Xval
    mov ecx, -5        ; ECX ← -5
    imul eax, ecx      ; EAX ← Xval * -5

    ; Save result of Xval * -5
    push eax           ; Push EAX (numerator) onto the stack

    ; Calculate Yval % Zval
    mov eax, [Yval]    ; EAX ← Yval (dividend)
    xor edx, edx       ; Clear EDX before division
    mov ecx, [Zval]    ; ECX ← Zval (divisor)
    test ecx, ecx      ; Check if divisor (Zval) is zero
    jz divide_error    ; Jump to error handler if zero
    div ecx            ; EAX ← Yval / Zval, EDX ← Yval % Zval

    ; Divide (Xval * -5) by (Yval % Zval)
    mov ebx, edx       ; EBX ← Yval % Zval (from EDX)
    test ebx, ebx      ; Check if EBX (divisor) is zero
    jz divide_error    ; Jump to error handler if zero

    pop eax            ; Restore numerator (Xval * -5)
    cdq                ; Sign-extend EAX into EDX for signed division
    idiv ebx           ; EAX ← (Xval * -5) / (Yval % Zval)

    call convert
    call print 

    ; Exit program
    call exit

divide_error:
    ; Handle division by zero error
    mov eax, 4         ; sys_write
    mov ebx, 1         ; stdout
    mov ecx, msg_error ; Address of error message
    mov edx, len_error ; Length of error message
    int 0x80           ; Call kernel
    call exit          ; Terminate program

convert:
    lea edi, [buffer + 16] ; Point EDI to the end of the buffer
    xor edx, edx           ; Clear remainder (EDX)
    
    test eax, eax          ; Check if EAX is negative
    jns .convert_loop      ; Skip if positive

    neg eax                ; Convert EAX to positive
    push eax
    mov eax, 4             ; sys_write
    mov ebx, 1             ; stdout
    mov ecx, msg_negative  ; Address of '-' character
    mov edx, 1             ; Length of 1
    int 0x80               ; Print '-'
    pop eax

.convert_loop:
    dec edi                ; Move EDI backward to store next character
    xor edx, edx           ; Clear remainder
    mov ecx, 10            ; Divisor (base 10)
    div ecx                ; EAX / ECX → EAX = quotient, EDX = remainder
    add dl, '0'            ; Convert remainder (EDX) to ASCII
    mov [edi], dl          ; Store ASCII digit in buffer
    test eax, eax          ; Check if quotient is zero
    jnz .convert_loop       ; Repeat until all digits are processed
    ret                    ; Return to caller

print:
    ; Write the result to console
    mov eax, 4             ; sys_write
    mov ebx, 1             ; stdout
    mov ecx, edi           ; ECX points to the start of the number string
    lea edx, [buffer + 16] ; End of buffer
    sub edx, ecx           ; Calculate string length
    int 0x80               ; Call kernel

    ; Add a newline character after the number
    mov eax, 4             ; sys_write
    mov ebx, 1             ; stdout
    mov ecx, newline       ; Address of newline character
    mov edx, 1             ; Length of newline character
    int 0x80               ; Call kernel
    ret                    ; Return to caller

exit:
    mov eax, 1             ; sys_exit
    xor ebx, ebx           ; Exit code 0
    int 0x80
