section .text
  global _main

_main:
	; SYSCALL: write(1, msg, len);
	mov rax, 0x2000004	; MacOS write function
	mov rdi, 1		
	mov rsi, msg		
	mov rdx, len		
	syscall


	; SYSCALL: exit(0)
	mov rax, 0x2000001	; exit function
	mov rdi, 0		       
	syscall

section .data
  msg db 'hello, world!', 0x0a    ; 0x0a = LF, 0x0d = CR
  len equ $ - msg