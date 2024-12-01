section .data
    text db "abqqba"
    len equ $ - text
    yes db "yes", 10
    no db "no", 10

section .bss

section .text
    global _start

_start:
    mov eax, len
    dec eax
    xor ebx, ebx

my_loop:
    cmp eax, ebx
    jl is_palin

    mov cl, [text + eax]
    mov dl, [text + ebx]
    cmp cl, dl
    jne not_palin

    inc ebx
    dec eax
    jmp my_loop

is_palin:
    mov eax, 4
    mov ebx, 1
    mov ecx, yes
    mov edx, 4
    int 0x80
    jmp end

not_palin:
    mov eax, 4
    mov ebx, 1
    mov ecx, no
    mov edx, 3
    int 0x80

end:
    mov eax, 1
    xor ebx, ebx
    int 0x80
