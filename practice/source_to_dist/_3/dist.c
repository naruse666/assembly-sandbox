func(int a) {
  int b = 0;     // sum とかの方がいいかも

  for (int i = 1; i <= a; i++) {
    b += i;
  }
  return b;
}