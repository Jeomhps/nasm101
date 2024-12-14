; -----------------------------------------------------
; Author: Jeomhps
; Date  : 2024-12-01
; -----------------------------------------------------

section .data
    text db "abccba"
    len equ $ - text
    
    msgPalin db "The string is a palindrome", 10
    lenPalin equ $ - msgPalin
    
    msgNotPalin db "The string is not a palindrome", 10
    lenNotPalin equ $ - msgNotPalin
    
    SYS_write equ 4
    STDOUT equ 1
    
    SYS_exit equ 1
    EXIT_SUCCESS equ 0

    ; Return value of the palin function
    isPalin equ 1
    isNotPalin equ 0

section .text
    global _start

_start:
    push len
    push text
    
    call palin

    add esp, 8 ; Clean the stack from the args
    
    jmp exit
    
palin:
    push ebp
    mov ebp, esp
    
    mov eax, [ebp + 8] ; Address of text
    mov ecx, [ebp + 12] ; len of text
    
    mov edx, 0

my_loop:
    cmp ecx, edx
    jbe is_palin

    mov cl, [text + ecx]
    mov dl, [text + edx]
    cmp cl, dl
    jne not_palin

    inc edx
    dec ecx
    jmp my_loop

is_palin:
    mov eax, SYS_write
    
    push ebx
    
    mov ebx, STDOUT
    mov ecx, msgPalin
    mov edx, lenPalin
    int 0x80
    
    pop ebx
    
    pop ebp

    mov eax, isPalin
    ret

not_palin:
    mov eax, SYS_write
    
    push ebx
    
    mov ebx, STDOUT
    mov ecx, msgNotPalin
    mov edx, lenNotPalin
    int 0x80
    
    pop ebx
    
    pop ebp

    mov eax, isNotPalin
    ret

exit:
    mov eax, SYS_exit
    mov ebx, EXIT_SUCCESS
    int 0x80
