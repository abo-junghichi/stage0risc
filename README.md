# stage0risc
stage0
https://savannah.nongnu.org/projects/stage0/
https://github.com/oriansj/stage0
の対象マシンが、あまりにも複雑な命令セットコンピュータ(CISC)で、bootstrapの障害になる。
そこで、MIPSプロセッサ並に単純な命令セットのRISCマシンでbootstrapを目指す。

## 構築済み
### 対象マシンのC言語実装
<pre>
$ gcc emu-aligin.c -o emu.out
</pre>
### 16進数表記テキストからバイトコードへの変換のC言語実装
<pre>
$ gcc hex.c -o hex.out
</pre>
### 16進数表記でのhello,world!プログラム
<pre>
$ ./hex.out < hello.hex > hello.img
$ ./emu.out < hello.img
Hello,World!
</pre>
### ブートローダ
<pre>
$ ./hex.out < bootloader.hex > bootloader.img
$ cat bootloader.img hello.img > bh.img
$ ./emu.out < bh.img
Hello,World!
$ cat bootloader.img bootloader.img bootloader.img hello.img > bbbh.img
$ ./emu.out < bbbh.img
Hello,World!
</pre>
