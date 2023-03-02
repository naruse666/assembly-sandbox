; Simple program 
; using systemcall write(4), read(3), exit(1)
; return 'Hello, <input name>'

%define STDIN 0
%define STDOUT 1

section .text
  global _main

_main:
  ; ask name
  mov rax, 0x2000004 ; sys_write 
  mov rdi, STDOUT
  mov rsi, userName
  mov rdx, lenUserName
  syscall

  ; read input
  mov rax, 0x2000003 ; sys_read
  mov rdi, STDIN     
  mov rsi, num
  mov rdx, 10
  syscall

  ; display return message
  mov rax, 0x2000004 ; sys_write
  mov rdi, STDOUT
  mov rsi, returnMsg
  mov rdx, lenReturnMsg
  syscall

  ; display user name
  mov rax, 0x2000004 ; sys_write
  mov rdi, 1
  mov rsi, num
  mov rdx, 10
  syscall

  ; exit
  mov rax, 0x2000001  ; sys_exit
  mov rdi, 0
  syscall

section .bss
  num resq 10         ; 10文字まで受付(Unicodeもいける)

section .data
  userName db 'Please enter your name: '
  lenUserName equ $-userName
  returnMsg db 'Hello, '
  lenReturnMsg equ $-returnMsg