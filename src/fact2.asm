; This emplementation fill the array in a different manner.

section .data
    number dd 7

section .bss
    tab resd 10

section .text
    global _start

_start:
    ; Always start at 1
    mov eax, 1
    mov ecx, tab

    ; Add 1 to the number for cmp
    add dword [number], 1

    call factorial

    ; Remove the duplicate at the end of the table
    sub dword [number], 1
    mov ebx, [number]
    mov dword [number + 4 * ebx], 0


    jmp exit

factorial:
    ; end case
    cmp eax, [number]
    je end_recursion

    push eax
    inc eax

    call factorial

    pop ebx
    imul eax, ebx

    mov [ecx], eax
    add ecx,4

    ret

end_recursion:
    mov eax, 1
    ret

exit:
    mov eax, 1
    xor ebx, ebx
    int 0x80
