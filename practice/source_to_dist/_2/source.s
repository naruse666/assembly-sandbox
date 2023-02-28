func:
  push rbp
  mov rbp, rsp
  mov eax, edi
  and eax, 0x1
  test eax, eax
  jne loc_612
  mov eax, 0x1
  jmp loc_617

loc_612:
  mov eax, 0x0
loc_617:
  pop rbp
  ret