; -----------------------------------------------------
; Author: Jeomhps
; Date  : 2024-12-10
; -----------------------------------------------------

; - This code has some drawbacks one being the fact that if the length of text1
; is greater than length of text2 it will cause segfault (at least is should)
; I'll work on a fix later.
;
; - On the same hand I do not like the variable name I used.

section .data
    text1 db "abccba"
    len1 equ $ - text1
    
    text2 db "abccba"
    len2 equ $ - text2

    msgIsEq db "The string are equals", 10
    lenEq equ $ - msgIsEq
    
    msgIsNotEq db "The string are not equals", 10
    lenNotEq equ $ - msgIsNotEq
    
    SYS_write equ 4
    STDOUT equ 1
    
    SYS_exit equ 1
    EXIT_SUCCESS equ 0

    isEq equ 1
    isNotEq equ 0

section .text
    global _start

_start:
    push len1
    push text2
    push text1
    
    call strcmp
    
    jmp exit
    
strcmp:
    push ebp
    mov ebp, esp
    
    mov esi, [ebp + 8] ; Address of text1
    mov edi, [ebp + 12] ; Address of text2
    mov ecx, [ebp + 16] ; Len1 on text1
    dec ecx

my_loop:
    mov al, [esi]
    mov bl, [edi]
    cmp al, bl
    
    jne isNotEqual
    
    inc esi
    inc edi
    
    loop my_loop

isEqual:
    mov eax, SYS_write
    mov ebx, STDOUT
    mov ecx, msgIsEq
    mov edx, lenEq
    int 0x80
    
    pop ebp

    mov eax, isEq
    ret

isNotEqual:
    mov eax, SYS_write
    mov ebx, STDOUT
    mov ecx, msgIsNotEq
    mov edx, lenNotEq
    int 0x80
    
    pop ebp

    mov eax, isNotEq
    ret

exit:
    mov eax, SYS_exit
    mov ebx, EXIT_SUCCESS
    int 0x80
