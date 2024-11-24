;Prg3:
;
;if ((var1 <= var2) && (var2 > var3)) {
; var4 = 5;
; var5 = 6;
;}

section .data
    var1 dd 3
    var2 dd 3
    var3 dd 2

section .bss
    var4 resd 1
    var5 resd 1

section .text

global _start

_start:
    mov eax, [var1]
    cmp [var2], eax
    jae cond1
    jmp exit

cond1:
    mov eax, [var2]
    cmp eax, [var3]
    ja cond2
    jmp exit

cond2:
    mov dword [var4], 5
    mov dword [var5], 6
    jmp exit

exit:
    mov eax, 1
    mov ebx, 0
    int 80h
