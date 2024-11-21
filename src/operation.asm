section .data
    Xval dd 5          ; Value of Xval
    Yval dd 10         ; Value of Yval
    Zval dd 3          ; Value of Zval
    newline db 0x0A    ; Newline character for cleaner output

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

    ; Exit program
    call exit

convert:
    lea edi, [buffer + 16] ; Point EDI to the end of the buffer
    xor edx, edx           ; Clear remainder (EDX)

convert_loop:
    dec edi                ; Move EDI backward to store next character
    xor edx, edx           ; Clear remainder
    mov ecx, 10            ; Divisor (base 10)
    div ecx                ; EAX / ECX → EAX = quotient, EDX = remainder
    add dl, '0'            ; Convert remainder (EDX) to ASCII
    mov [edi], dl          ; Store ASCII digit in buffer
    test eax, eax          ; Check if quotient is zero
    jnz convert_loop       ; Repeat until all digits are processed
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
