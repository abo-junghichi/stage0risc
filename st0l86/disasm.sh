#!/bin/sh

#ndisasm -b 32 -o 0x1000000 -k 0x1000000,116 -s 0x1000138 /dev/stdin
ndisasm -b 32 -o 0x1000000 -k 0x1000000,116 /dev/stdin
