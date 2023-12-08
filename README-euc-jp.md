# stage0risc
[Stage0 Bootstrap for the Free Software](https://savannah.nongnu.org/projects/stage0/)
の対象マシンが、あまりにも複雑な命令セットコンピュータ(CISC)で、
bootstrapの障害になる。
そこで、MIPSプロセッサ並に単純な命令セットのRISCマシンでbootstrapを目指す。

## マルチパスにコンパイラを分解する

[なぜ関数プログラミングは重要か](https://www.sampou.org/haskell/article/whyfp.html)

> 元の問題を分割する方法は、部分解を貼り合せる方法に直接依存する。

bootstrapを単一のバイナリから始めようとする場合、
そのバイナリコンパイラを最小化するためには、
バイナリと同程度の可読性しか持たないものを
ソースコードとして扱わねばならない。
更に悪いことに、bootstrap作業の段階を進め、
新しい機能をコンパイラに追加する度に、
前の段階で実装済みだったすべての機能を、
新しいコンパイラの言語で再実装しなければならない。
この再実装の繰り返しは、バイナリの指数関数的な肥大を招き、
バグや悪意のあるコードが忍び込む隙を作り出す。
その肥大速度は指数関数的であって、線形ではない。
なぜなら、コンパイラに追加した機能により、
肥大したコードを書くことが簡単になるからだ。

例として、stage0での初期に生成されるバイナリのサイズを以下に示す。

<pre>
342     stage0_monitor
250     stage1_assembler-0 //hex->binary converter
472     stage1_assembler-1 //single character labels
1006    stage1_assembler-2 //64 char labels & more addressing modes
1504    M0 //line macro assembler
</pre>

この二つの問題のうち後者については、
[Minimal Binary Boot](https://codeberg.org/StefanK/MinimalBinaryBoot)
で示された様に、
前の段階でコンパイル済みのバイナリに追加する形でコンパイルを進める、
増分コンパイルの手法によって避けることができる。

対してここでは、両方の問題を解決する別の方法として、
[パンチカードシステム](https://ja.wikipedia.org/wiki/%E3%83%91%E3%83%B3%E3%83%81%E3%82%AB%E3%83%BC%E3%83%89%E3%82%B7%E3%82%B9%E3%83%86%E3%83%A0)
に倣ってコンパイラを複数のフィルタプログラムに分解するものを使う。
ソースコードをあるフィルタに読み込ませ、
その出力を別のフィルタに入力することで、
全体としてコンパイラの動作を行わせるものだ。
この方法により、バイナリの検査をもっと簡単にできる。
分割されているため個々のフィルタのバイナリは小さい。
個々のフィルタの中間出力も検査できる。
そして、それらのフィルタは全て、
マトモなプログラミング言語で記述されたソースコードから構築される。

## 最初のコンパイラを構成するフィルタ群
### autolabel
numlabelフィルタで扱えるよう、各ラベルに番号を振る。

### linemacro
文字列とキーワードの組で構成された定義を読み込み、
以後読み込むキーワードをそれに対応する文字列で置き換える。
ニーモニックの実装に使う。
また、キーワードのない定義はコメント表記に使える。

### numlabel
前方アドレス参照機能しかないバイナリエディタ。
自身のバイナリサイズを最小化するため、
後方参照機能は実装していないし、ラベルは文字列ではなく番号で参照。
さらに、ラベル番号やバイトは4進数で表記する。

### genheader
numlabelフィルタでは後方ジャンプができないのに、
ここで使うプロセッサはプログラム先頭から命令実行を始める。
なのでこのフィルタは、プログラム最後尾にジャンプするコードを生成する。
ついでにこのコードに、ブートローダに教えるプログラムサイズを付加し、
先頭領域データとして出力する。
バイナリサイズを最小化するため、
このフィルタが出力するのは先頭領域データのみ。
ここで使うシステムは穿孔テープやパンチカードを入出力に用いるので、
先頭領域データをプログラムに加えるのは手作業で可能。

## 構築済み

### 対象マシンのC言語実装
<pre>
$ make emu-fast.out
</pre>
emu-fast.out以外にも、構築可能な実装がある。
Makefileやemu-\*.cを参照。

### hello,world!プログラム
<pre>
$ make hello
</pre>

### 最初のコンパイラを構成するバイナリ群を再生成できるか検証
<pre>
$ make test
</pre>

### ブートローダのchainload
<pre>
$ make hello
Hello,World!
$ cat bootloader.img bootloader.img bootloader.img hello.test > bbbh.test
$ ./emu-fast.out < bbbh.test
Hello,World!
</pre>

### バイナリを減らす
<pre>
$ make minblob
$ make clean
</pre>

減らしたバイナリを復元する。

<pre>
$ make minboot
</pre>
