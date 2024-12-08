section .data
    number dd 2
    message db 'Number in binary : '

section .bss
    str_bin resb 33

section .text
    global _start

_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, message
    mov edx, 19
    int 80h

    mov eax, [number]
    call print_bin

    jmp exit


print_bin:
    mov ecx, 32
    mov edi, str_bin

conv_loop:
    shl dword eax, 1
    jnc null_bit
    mov byte [edi], '1'
    jmp next_bit

null_bit:
    mov byte [edi], '0'

next_bit:
    inc edi
    loop conv_loop
    mov byte [edi], 0

end_conv:
    mov eax, 4
    mov ebx, 1
    mov ecx, str_bin
    mov edx, 32
    int 80h
    ret

exit:
    mov eax, 1
    xor ebx, ebx
    int 80h
