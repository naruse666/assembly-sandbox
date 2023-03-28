# 文字列の比較してみた
testを使用。
```
_main:
  mov rax, stra
  test rax, 'a'
  je write        ; 文字列の比較 je, jz = true; jne, jnz = false
  jmp exit
```

cmp使用。
```
_main:
  mov rax, stra
  cmp rax, 'a'
  je write        ; 文字列の比較 je, jz = false; jne, jnz = true
  jmp exit
```