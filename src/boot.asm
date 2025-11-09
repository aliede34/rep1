; 32-bit multiboot-compliant kernel entry point written in NASM assembly.
; This code prints a short string to the VGA text buffer and halts the CPU.

BITS 32

section .multiboot
align 4
MBALIGN   equ 1 << 0
MEMINFO   equ 1 << 1
FLAGS     equ MBALIGN | MEMINFO
MAGIC     equ 0x1BADB002
CHECKSUM  equ -(MAGIC + FLAGS)

dd MAGIC
dd FLAGS
dd CHECKSUM

section .text
align 16

global start
start:
    mov esp, stack_top
    call kmain

.hang:
    cli
    hlt
    jmp .hang

; The C-style entry point that writes a message.
; It expects to run in 32-bit protected mode with a flat memory model.

kmain:
    mov esi, message
    mov edi, 0xB8000

.write_loop:
    lodsb
    test al, al
    jz .done
    mov ah, 0x0F
    stosw
    jmp .write_loop

.done:
    ret

section .rodata
message db "Merhaba! 32-bit çekirdeğiniz yüklendi.", 0

section .bss
align 16
stack_bottom:
    resb 4096
stack_top:
