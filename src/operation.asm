section .data
    Xval dd 5          ; Value of Xval
    Yval dd 10         ; Value of Yval
    Zval dd 3          ; Value of Zval

section .bss
    buffer resb 16     ; Buffer to store the result as a string

section .text
    global _start

_start:
    ; Rval = -Xval + (Yval – Zval)

    ; Calculate -Xval
    mov eax, [Xval]
    neg eax

    ; Calculate (Yval - Zval)
    mov ebx, [Yval]
    sub ebx, [Zval]

    ; Add the two results: -Xval + (Yval - Zval)
    add eax, ebx       ; EAX ← -Xval + (Yval - Zval)

    ; Step 4: Convert EAX (Rval) to string
    lea edi, [buffer + 15] ; Point EDI to the end of the buffer
    mov byte [edi], 0x0A   ; Add newline character to the end, could write 10
    xor edx, edx           ; Clear EDX for the division loop

convert:
    dec edi                ; Move EDI backward to store next character
    xor edx, edx           ; Clear remainder
    mov ecx, 10            ; Divisor (base 10)
    div ecx                ; EAX / ECX → EAX = quotient, EDX = remainder
    add dl, '0'            ; Convert remainder (EDX) to ASCII
    mov [edi], dl          ; Store ASCII digit in buffer
    test eax, eax          ; Check if quotient is zero
    jnz convert            ; Repeat until all digits are processed

    ; Step 5: Write the result to console
    mov eax, 4             ; sys_write
    mov ebx, 1             ; stdout
    lea ecx, [edi]         ; ECX points to the start of the number string
    lea edx, [buffer + 16] ; End of buffer
    sub edx, ecx           ; Calculate string length
    int 0x80               ; Call kernel

    ; Step 6: Exit program
    mov eax, 1             ; sys_exit
    xor ebx, ebx           ; Exit code 0
    int 0x80
