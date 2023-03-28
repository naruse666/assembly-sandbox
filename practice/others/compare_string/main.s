section .text
  global _main

_main:
  mov rax, stra
  test rax, 'a'
  je write        ; 文字列の比較
  jmp exit

write:
  mov rax, 0x2000004 ; write
  mov rdi, 1
  mov rsi, isa
  mov rdx, lenIsa
  syscall
exit:
  mov rax, 0x2000001  ; exit
  mov rdi, 0
  syscall

section .data
  stra db 'a'
  isa dq 'str is a', 0x0a
  lenIsa equ $-isa