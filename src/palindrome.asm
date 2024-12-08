section .data
    text db "abqcba"
    len equ $ - text
    
    msgPalin db "The string is a palindrome", 10
    lenPalin equ $ - msgPalin
    
    msgNotPalin db "The string is not a palindrome", 10
    lenNotPalin equ $ - msgNotPalin
    
    SYS_write equ 4
    STDOUT equ 1

    SYS_exit equ 1
    EXIT_SUCCESS equ 0

section .text
    global _start

_start:
    mov eax, len
    dec eax
    xor ebx, ebx

my_loop:
    cmp eax, ebx
    jbe is_palin

    mov cl, [text + eax]
    mov dl, [text + ebx]
    cmp cl, dl
    jne not_palin

    inc ebx
    dec eax
    jmp my_loop

is_palin:
    mov eax, SYS_write
    mov ebx, STDOUT
    mov ecx, msgPalin
    mov edx, lenPalin
    int 0x80
    jmp end

not_palin:
    mov eax, SYS_write
    mov ebx, STDOUT
    mov ecx, msgNotPalin
    mov edx, lenNotPalin
    int 0x80

end:
    mov eax, SYS_exit
    mov ebx, EXIT_SUCCESS
    int 0x80
