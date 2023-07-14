{
bootloader in the rom.
}
{b}pass
{1b}one
{2b}tmp
{3b}len
{10b}addr
0330b b b b                  {4byte header of little endian of program size.}
lit one 1b b                 {set the constant.}
lit pass 1b b                {reading the file of header is first pass.}
lit len 10b b                {length of the header is 4byte.}
{3} rel addr 0300b b {+data} {set where read content is put.}
{4} jal tmp 0110b b {+read}

:{@}-loop
getc tmp b b
sb tmp b addr
add addr addr one
sub len len one
{9} :{1@}-read
bnez len -loop

{10} beqz pass 0110b b {+data} {if second pass is done, chainload.}
lit pass b b                   {seccond pass}
{12} rel addr 0030b b {+data}
{the content of the header read at first pass is remaining file size.}
ld len b addr
jal tmp -read
{15} {:data}
