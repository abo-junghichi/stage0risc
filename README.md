# stage0risc
stage0
https://savannah.nongnu.org/projects/stage0/
https://github.com/oriansj/stage0
���оݥޥ��󤬡����ޤ�ˤ�ʣ����̿�᥻�åȥ���ԥ塼��(CISC)�ǡ�bootstrap�ξ㳲�ˤʤ롣
�����ǡ�MIPS�ץ��å��¤�ñ���̿�᥻�åȤ�RISC�ޥ����bootstrap���ܻؤ���

## ���ۺѤ�
### �оݥޥ����C�������
<pre>
$ gcc emu-aligin.c -o emu.out
</pre>
### 16�ʿ�ɽ���ƥ����Ȥ���Х��ȥ����ɤؤ��Ѵ���C�������
<pre>
$ gcc hex.c -o hex.out
</pre>
### 16�ʿ�ɽ���Ǥ�hello,world!�ץ����
<pre>
$ ./hex.out < hello.hex > hello.img
$ ./emu.out < hello.img
Hello,World!
</pre>
### �֡��ȥ���
<pre>
$ ./hex.out < bootloader.hex > bootloader.img
$ cat bootloader.img hello.img > bh.img
$ ./emu.out < bh.img
Hello,World!
$ cat bootloader.img bootloader.img bootloader.img hello.img > bbbh.img
$ ./emu.out < bbbh.img
Hello,World!
</pre>
