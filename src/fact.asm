section .bss
    tab resd 10
    buffer resb 16

section .text
    global _start

_start:
    mov eax, 5
    mov dword [tab], 1
    mov ecx, tab

    call factorial

    jmp exit

factorial:
    ; base case
    cmp eax, 1
    je end_recursion

    push eax
    dec eax

    call factorial

    pop ebx
    imul eax, ebx

    add ecx,4
    mov [ecx], eax

    ret

end_recursion:
    mov eax, 1
    ret

exit:
    mov eax, 1
    xor ebx, ebx
    int 0x80
