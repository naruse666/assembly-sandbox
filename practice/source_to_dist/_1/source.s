func:
  push rbp
  mov rbp, rsp
  mov DWORD PTR [rbp-0x4], edi
  mov DWORD PTR [rbp-0x8], esi
  mov eax, DWORD PTR [rbp-0x4]
  movsxd rdx, eax
  mov eax, DWORD PTR [ebp-0x8]
  movsxd rax, eax
  imul rax, rdx
  pop rbp
  ret