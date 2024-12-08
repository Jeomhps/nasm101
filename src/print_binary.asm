section .data
    number dd 2
    message db 'Number in binary : '
    msg_len equ $ - message

    ; SYS_WRITE header
    SYS_WRITE equ 4
    STDOUT equ 1

    ; SYS_EXIT header
    SYS_EXIT equ 1
    EXIT_SUCCESS equ 0

    ; Binary string repr buffer
    str_bin_len equ 32

section .bss
    str_bin resb 32

section .text
    global _start

_start:
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, message
    mov edx, msg_len
    int 80h

    mov eax, [number]
    call print_bin

    jmp exit


print_bin:
    mov ecx, str_bin_len ; We loop 32 times since an int is 32 bit
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
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, str_bin
    mov edx, str_bin_len
    int 80h
    ret

exit:
    mov eax, SYS_EXIT
    mov ebx, EXIT_SUCCESS
    int 80h
