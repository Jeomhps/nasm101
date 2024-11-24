;Prg4:
;
;while (val1 < val2) {
;    val1++
;    if (val2 == val3) {
;        x = 2
;    } else {
;        x = 3
;    }
;}

section .data
    val1 dd 0
    val2 dd 3
    val3 dd 2

section .bss
    x resd 1

section .text

global _start

_start:
    mov eax, [val1]
    jmp while

while:
    cmp eax, [val2]
    jae exit
    inc eax
    mov ebx, [val2]
    cmp ebx, [val3]
    je true
    ;else
    mov dword[x], 3
    jmp while

true:
    mov dword [x], 2
    jmp while

exit:
    mov eax, 1
    mov ebx, 0
    int 80h
