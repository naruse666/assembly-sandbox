func:
  push rbp
  mov rbp, rsp
  mov DWORD PTR [rbp-0x14], edi
  mov DWORD PTR [rbp-0x8], 0x0
  mov DWORD PTR [rbp-0x4], 0x1
  jmp loc_61b
loc_611:
  mov eax, DWORD PTR [rbp-0x4]
  add DWORD PTR [rbp-0x8], eax
  add DWORD PTR [rbp-0x4], 0x1

loc_61b:
  mov eax, DWORD PTR [rbp-0x4]
  cmp eax, DWORD PTR [rbp-0x14]
  jle loc_611
  mov eax, DWORD PTR [rbp-0x8]
  pop rbp
  ret