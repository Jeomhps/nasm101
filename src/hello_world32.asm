section .data
    text db "Hello World !", 10 ; 10 is '\n'

section .text
    global _start

_start:
    ; sys_write(code 4)(stdout=1, *buffer, length) so arg1, arg2, arg3
    mov eax, 4
    mov ebx, 1    ; stdout
    mov ecx, text ; buffer addresse like a pointer
    mov edx, 14   ; length of string + '\n'
    int 0x80      ; syscall in 32 bits

    ; sys_exit(code 1)(status=0)
    mov eax, 1
    mov ebx, 0 ; EXIT_SUCCESS
    int 0x80
