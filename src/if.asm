;Prg1.c:
;
;if (op1 == op2)
;    x = 1;
;else
;    x = 2;

section .data
    op1 dd 3
    op2 dd 4

section .bss
    x resd 1

section .text

global _start

_start:
    mov eax, [op1]
    cmp eax, [op2]
    je if
    mov dword [x], 2
    jmp exit

if:
    mov dword [x], 1
    jmp exit

exit:
    mov eax, 1
    mov ebx, 0
    int 80h
