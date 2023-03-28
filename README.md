# assembly-sandbox
[nasm](https://www.nasm.us/)というアセンブラを使い、アセンブルする。
```nasm -f macho64 <file>```

# systemcall
[syscalls.master](https://github.com/apple/darwin-xnu/blob/main/bsd/kern/syscalls.master)

### 番号
[リンク](https://thexploit.com/secdev/mac-os-x-64-bit-assembly-system-calls/).  
unixのシステムコール番号に`0×2000000`を足すみたい。  恐らくカーネルコマンドのoffsetが`0×2000000`ってこと？
```0x2000001 ; exitを呼べる。```

# Linux systemcall リファレンス
めっちゃ見やすいのあった。
[yamnikov-oleg/calling_conventions.md](https://gist.github.com/yamnikov-oleg/454f48c3c45b735631f2)

# アセンブリ基礎
x86_64の。
## 記法
### レジスタ
```
64bit    32bit    16bit    下位2byte    最下位byte
---------------------------------------------------
rax      eax      ax        ah          al
rdx      edx      dx        dh          dl
rsi      esi      si        -           sil
rdi      edi      di        -           dil
rsp      esp      sp        -           spl
rbp      ebp      bp        -           bpl
r8       r8d      r8w       -           r8b
r12      r12d     r12w      -           r12b
```

### オペコードとオペランド
命令には1つのオペコードと,0個以上のオペランドがある。  
この場合は`add`がオペコード。  
`rax, 10`がオペランド。(第一オペランドはしばしばdestinationとなる。)
```add rax, 10```

アドレスは[]で囲む必要がある. `[]`の中で算術演算も可能。
```add rax, [0x123456]```

`addq`などオペコードのサフィックスに文字があるが以下の様な意味。
```
b : byte (8bit)
w : word (16bit)
l : long word (32bit)
q : quad word (64bit)
```

### コメントアウト
`;`をつける。
```add rax, 10 ; add 10 to rax```

## 算術計算
### 加減算
```
add A, B 
sub A, B 
```

### インクリメント、デクリメント
```
inc rax
dec rax
```

### 乗算
```
mov rax, 2   ; raxに2を代入
mov rcx, 3   ; rcxに3を代入
mul rcx      ; オペランドは1つのみ。 raxレジスタの値と乗算する。
```
計算結果は上半分が`rdx`レジスタに、下半分が`rax`レジスタに入る。(64bit同士の乗算は整数オーバーフローの可能性がある)  

第一オペランドが32bitであれば,`edx`, `eax`に入る。
```
mov rax, 0xabcdabcd
mov rdx, 0x12341234
mul edx              ; 32bitのためrdxではない
```

### 除算
基本乗算と同じ、被除数は`rax`レジスタ。  
計算結果は`rax`に商、`rdx`に剰余が入る。
```
mov rax, 21
mov rdx, 5
div rdx
```

### 論理演算
```
and rax, rdx  ; raxとrdxのANDをraxに格納
or  rax, rdx  ; rax, rdxの論理和(OR)をraxに格納
xor rax, rdx  ; rax, rdxのXOR.  xor eax, eaxの様にするとレジスタを0にできる。仕様上raxレジスタ全体が0になる。
not rax       ; raxのNOT
```

### シフト演算
`shr`, `shl`で右左のシフト。オペランドが一つなら1bitシフトする。
```
shl rax  ; rax <<= 1
shr rax  ; rax >>= 1
```

オペランドが二つの場合。第二オペランドには**即値もしくはclレジスタ**のみ指定可能。
```
mov cl, 3
shl rax, cl  ; rax <<= 3
shr rax, 10  ; rax >>= 10
```

## 比較
### cmp
比較結果を**フラグレジスタ**に保存する。 
第一オペランドと第二オペランドの**差**でチェックしている。 
フラグレジスタ一例
```
フラグ     意味            1になる条件
ZF         Zero flag       演算結果が0
SF         Signed flag     演算結果が負数
CF         Carry flag      演算で桁あふれ
OF         Overflow flag   符号付演算で桁あふれ
```

`ZF=1, SF=0, CF=0, OF=0`になる例。
```
mov rax, 10
mov rdx, 10
cmp rax, rdx
```

### test
2つのオペランドのANDでフラグを設定する。  
`ZF=0`(ゼロか判断)の例
```
test rax, rax
```

## 分岐
### jmp
gotoみたいな。ラベルに飛ぶ。
```
jmp func  ; funcに飛ぶ
...
func:     ; funcラベル
...
```

### jz, je
`jz = jump if zero`, `je = jump if equal`の略。
```
cmp rax, 10
jz a        ; ZF=1ならaにjmp
  ...
a:
  ...
```

### jnz, jne
`jz, je`のnot条件。
```
cmp rax, 10
jne a       ; ZF=0でaにjmp
  ...
a:
  ...
```

### ja, jae
`jump if avobe`のこと`>, >=`にあたる。  
jaは`ZF=0かつCF=0`の時。jaeは`CF=0`の時。
```
cmp rax, 10
ja a        ; rax > 10 でaにjmp
  ...
a:
  ...
```

### jb, jbe
`jump if below`.  
jbは`CF=1`, jbeは`CF=1 or ZF=1`.
```
cmp rax, 10
jbe a       ; rax <= 10 でaにjmp
  ...
a:
  ...
```

### jg, jge, jl, jle
ja, jae, jb, jbeを符号付で比較。  
jgは`ZF=0 and SF=OF`, jgeは`SF=OF`.  
jlは`SF!=OF`, jleは`SF!=OF or ZF=1`.

## スタック操作
pushはrspを減算し、popはrspを加算する。  
pop処理で対象アドレスの値は削除されないが、pushで上書きされることで消える。
```
push A
pop  A
```

## 関数呼び出し
`call`と`ret`がある。`jmp`の様にラベルに飛べるが、`ret`で戻れる。  
なぜ戻れるのか? -> callで次の命令をスタックに`push`し、retで`pop`して`rip`レジスタに設定します。
```
func:
  ...
  ret
main:
  ...
  call func  ; func にjmp
  ...        ; ret で戻ってくる
```

### 呼び出し
`call`, `ret`で行う。 
引数には`rdi, rsi, rdx, r10, r8, r9`レジスタを順番に使う。  
これは[ABI(Application Binary Interface)](https://ja.wikipedia.org/wiki/%E3%82%A2%E3%83%97%E3%83%AA%E3%82%B1%E3%83%BC%E3%82%B7%E3%83%A7%E3%83%B3%E3%83%90%E3%82%A4%E3%83%8A%E3%83%AA%E3%82%A4%E3%83%B3%E3%82%BF%E3%83%95%E3%82%A7%E3%83%BC%E3%82%B9)の作法で、第一引数は`rdi`,.... ということ。  

**関数の戻り値は`rax`に入る。**

### leave
retの直前にleaveが使われることがある。  
`mov rsp, rbp; pop rbp;`と等価。

### システムコール
`syscall`が用意されています。  

## 変数の保存
### ローカル変数
次のように確保される。
- `call`で呼び出す関数の先頭にjmpし戻り先のアドレスをスタックに積む
- `rbp`の値をスタックに積む
- `rbp`に`rsp`を代入する
- 使いたい領域分を`sub rsp, [0x000]`の様にひく  <- ここで領域確保
実行終了時、
- `leave`を読んで`rbp, rsp`を元に戻す
- `ret`で戻り先アドレスを`pop`してjmp

### グローバル変数
固定アドレスで保存される。
```mov eax, DWORD PTR [0x102030]  ; 0x102030 から4バイト取得```

## 配列
この様な配列を参照する。
```int array[] = {1, 2, 3, 4};```

`lea`でint型なので4バイトをかけている.
```
mov rax, [rbp - 0x8]  ; i の定義
lea rdx, [rax * 4]      
lea rax, [0x102030]   ; arrayのアドレスを仮に 0x102030 とする
mov eax, [rax + rdx]    ; eax = array[i]
```

# 逆アセンブル
バイナリからアセンブリへの変換。  
`objdump -S <file>`とか使う。

# variable
### Allocating Storage Space for Initialized Data
data section内。
```
Directive	  Purpose	           Storage Space
DB	        Define Byte	       allocates 1 byte
DW	        Define Word	       allocates 2 bytes
DD	        Define Doubleword	 allocates 4 bytes
DQ	        Define Quadword  	 allocates 8 bytes
DT	        Define Ten Bytes	 allocates 10 bytes
```

### Allocating Storage Space for Uninitialized Data
bss section内。
```
Directive	  Purpose
RESB	      Reserve a Byte
RESW	      Reserve a Word
RESD	      Reserve a Doubleword
RESQ	      Reserve a Quadword
REST	      Reserve a Ten Bytes
```

### Multiple Initializations
allocate `000000000`.
```marks  TIMES  9  DW  0```