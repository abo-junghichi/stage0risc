CC=gcc -O3 -Wall -Wextra -Wstrict-aliasing=1

clean:
	rm *.img *.out rom.c emu-align-gnu-sisc.c emu-align-fast.c
all: emu.out emu-fast.out

hex.out: hex.c
	$(CC) hex.c -o hex.out
img2c.out: img2c.c
	$(CC) img2c.c -o img2c.out
bootloader.img: bootloader.hex hex.out
	./hex.out < bootloader.hex > bootloader.img
rom.c: img2c.out bootloader.img
	./img2c.out < bootloader.img > rom.c
emu.out: emu-align.c rom.c
	$(CC) -pedantic emu-align.c -o emu.out
emu-gnu.out: emu-align-gnu.c rom.c
	$(CC) emu-align-gnu.c -o emu-gnu.out
emu-align-fast.c: emu-align-gnu.c emu-fast.patch
	cp emu-align-gnu.c emu-align-fast.c
	patch emu-align-fast.c emu-fast.patch
emu-fast.out: emu-align-fast.c rom.c
	$(CC) -pedantic emu-align-fast.c -o emu-fast.out
emu-align-gnu-sisc.c: emu-align-gnu.c emu-sisc.patch
	cp emu-align-gnu.c emu-align-gnu-sisc.c
	patch emu-align-gnu-sisc.c emu-sisc.patch
emu-sisc.out: emu-align-gnu-sisc.c rom.c
	$(CC) emu-align-gnu-sisc.c -o emu-sisc.out
