section .text
  global _main

_main:
  mov rax, 3
  mov rbx, 0
  mov rcx, x
top:
 add rbx, [rcx]
 add rcx, 1
 dec rax
 jnz top

  add rbx, '0'
  mov [rel sum], rbx

write:
  mov rax, 0x2000004 ; write
  mov rdi, 1
  mov rsi, sum
  mov rdx, 1
  syscall
exit:
  mov rax, 0x2000001  ; exit
  mov rdi, 0
  syscall

section .bss
  string resq 16

section .data
  x db 1, 2, 3
  first db 'input: '
  stra db 'a'
sum:
  db 0