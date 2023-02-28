func (int a){
  if( a % 2 == 0){ // 論理積を test eax, eaxとすることで偶数チェックできる。
    return 1;      // eax が戻り値
  } else {
    return 0;
  }
}