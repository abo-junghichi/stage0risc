CC=gcc -O3 -Wall -Wextra -Wstrict-aliasing=1

clean:
	rm *.out *.img

hexrel.out: hexrel.c
	$(CC) hexrel.c -o hexrel.out
test.img: hexrel.out test.S
	$(CC) -E test.S | ./hexrel.out > test.img
