bits 64 ; Set the code to 64-bit mode

section .text

global _start ; Entry point for 64-bit code

_start:
    ; Set up the stack (RSP) to a suitable address
    mov rsp, 0x7FFFFFFF0000 ; Adjust this address as needed

    ; Output a message
    mov rdi, hello_msg ; Load the address of the message
    call print_string

    ; Halt
    hlt

print_string:
    ; Output the null-terminated string in RDI
.loop:
    movzx rax, byte [rdi] ; Load the next character into RAX
    test  al, al           ; Check if it's the null terminator
    jz    .done            ; If it is, we're done
    mov   rsi, rax         ; Move the character to RSI for BIOS function
    mov   rax, 0x0E0F      ; BIOS teletype function (AH=0x0E, AL=character, BH=page, BL=foreground/background color)
    mov   bh, 0x00         ; Page (0x00 is the default)
    mov   bl, 0x07         ; Color (0x07 is white on black)
    int   0x10             ; Video BIOS interrupt
    inc   rdi               ; Move to the next character
    jmp   .loop

.done:
    ret

section .data
hello_msg db "Hello, World!", 0

times 510-($-$$) db 0
dw 0xAA55
