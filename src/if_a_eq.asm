;Prg2:
;
;if (var1 <= var2) {
;    var3 = 10;
;} else {
;    var3 = 6;
;    var4 = 7;
;}

section .data
    var1 dd 3
    var2 dd 5
    
section .bss
    var3 resd 1
    var4 resd 1

section .text

global _start

_start:
    mov eax, [var1]
    cmp [var2], eax
    jae above_eq
    mov dword [var3], 6
    mov dword [var4], 7
    jmp exit

above_eq:
    mov dword [var3], 10
    jmp exit

exit:
    mov eax, 1
    mov ebx, 0
    int 80h
