#include <stddef.h>
#include <stdio.h>
#include <assert.h>
static int dehex_part(int base, int floor, int ceiling, char hex, int *rst)
{
    if (base > hex)
	return 0;
    hex += floor - base;
    if (ceiling <= hex)
	return 0;
    *rst = hex;
    return 1;
}
static int dehex(char hex, int *rst)
{
    return dehex_part('0', 0, 10, hex, rst)
	|| dehex_part('A', 10, 16, hex & ~0x20, rst);
}
static int get_key(int *peek)
{
    *peek = fgetc(stdin);
    switch (*peek) {
    case EOF:
	return 2;
    case ' ':
    case '\n':
    case '\t':
	return 1;
    default:
	return 0;
    }
}
typedef union {
    size_t size;
    char image[1];
} cell;
#define MEM_SIZE (100000)
static cell mem[MEM_SIZE];
typedef enum {
    block_bytes, block_label, block_field_forth, block_field_back,
    block_word_forth, block_word_back, block_end
} block_type;
typedef struct {
    size_t type, prev, bytes, next;
} block_header;
typedef struct {
    size_t prev, pos;
    char *image;
} parse_state;
static void succeed_parse(parse_state *ps, size_t next)
{
    ps->prev = ps->pos;
    ps->pos = next;
    ps->image = mem[ps->pos + 4].image;
}
static void flush_block(parse_state *ps, block_type type)
{
    size_t bytes = ps->image - mem[ps->pos + 4].image, next;
    if (block_bytes == type && 0 == bytes)
	return;
    next = ps->pos + (bytes + (5 * sizeof(cell) - 1)) / sizeof(cell);
    mem[ps->pos + 0].size = type;
    mem[ps->pos + 1].size = ps->prev;
    mem[ps->pos + 2].size = next;
    mem[ps->pos + 3].size = bytes;
    succeed_parse(ps, next);
}
static void flush_bytes(parse_state *ps)
{
    flush_block(ps, block_bytes);
}
static void emit_block(parse_state *ps, block_type first_type,
		       int next_letter, block_type next_type)
{
    int peek;
    char *image;
    block_type type = first_type;
    flush_bytes(ps);
    image = ps->image;
    while (0 == get_key(&peek))
	*ps->image++ = peek;
    if (-1 != next_letter && ps->image > image && next_letter == *image)
	type = next_type;
    flush_block(ps, type);
}
static int parse_src(void)
{
    int rtn;
    parse_state ps;
    ps.pos = 0;
    mem[0].size = block_end;
    succeed_parse(&ps, 1);
    while (1) {
	int peek;
	int upper, lower;
	while (1)
	    switch (get_key(&peek)) {
	    case 0:
		goto head_done;
	    case 2:
		rtn = 0;
		goto end;
	    }
      head_done:
	switch (peek) {
	case '#':
	    while (1) {
		switch (fgetc(stdin)) {
		case EOF:
		case '\n':
		    goto comment_done;
		}
	    }
	  comment_done:
	    continue;
	case ':':
	    emit_block(&ps, block_label, -1, block_label);
	    continue;
	case '+':
	    emit_block(&ps, block_field_forth, '+', block_word_forth);
	    continue;
	case '-':
	    emit_block(&ps, block_field_back, '-', block_word_back);
	    continue;
	}
	if (dehex(peek, &upper) && dehex(fgetc(stdin), &lower)
	    && 0 != get_key(&peek))
	    *ps.image++ = upper << 4 | lower;
	else {
	    rtn = 1;
	    goto end;
	}
    }
  end:
    flush_bytes(&ps);
    mem[ps.pos + 0].size = block_end;
    return rtn;
}
static size_t image_length(cell *block)
{
    switch (block[0].size) {
    case block_bytes:
	return block[3].size;
    case block_label:
	return 0;
    case block_field_forth:
    case block_field_back:
	return 2;
    case block_word_forth:
    case block_word_back:
	return 4;
    }
    assert(0);
}
static int compile_int(size_t bytes, ptrdiff_t integer)
{
    size_t i;
    for (i = 0; i < bytes; i++) {
	if (EOF == fputc(integer, stdout))
	    return 1;
	integer >>= 8;
    }
    return 0;
}
static int charcmp(const char *tgt, const char *std, size_t n)
{
    while (n--)
	if (*tgt++ != *std++)
	    return 1;
    return 0;
}
static int labelsearch(int direction, cell *block, size_t label_base,
		       ptrdiff_t *rel)
{
    size_t len;
    cell *tmp = block;
    int dpos = direction ? 2 : 1;
    while (1) {
	tmp = &mem[tmp[dpos].size];
	switch (tmp[0].size) {
	case block_label:
	    len = block[3].size - label_base;
	    if (tmp[3].size != len)
		continue;
	    if (charcmp(tmp[4].image, block[4].image + label_base, len))
		continue;
	    return 0;
	case block_end:
	    return 1;
	default:
	    len = image_length(tmp);
	    if (direction)
		*rel += len;
	    else
		*rel -= len;
	}
    }
}
static int compile(void)
{
    ptrdiff_t rel;
    cell *block;
    for (rel = 0, block = &mem[1]; block_end != block[0].size;
	 block = &mem[block[2].size])
	rel += image_length(block);
    if (compile_int(4, rel))
	goto error;
    for (block = &mem[1];; block = &mem[block[2].size]) {
	switch (block[0].size) {
	case block_bytes:
	    if (1 != fwrite(block[4].image, block[3].size, 1, stdout))
		goto error;
	    continue;
	case block_label:
	    continue;
	case block_field_forth:
	    rel = 4;
	    if (labelsearch(1, block, 0, &rel))
		goto error;
	    goto compile_field;
	case block_field_back:
	    rel = 2;
	    if (labelsearch(0, block, 0, &rel))
		goto error;
	    goto compile_field;
	case block_word_forth:
	    rel = 4;
	    if (labelsearch(1, block, 1, &rel))
		goto error;
	    goto compile_word;
	case block_word_back:
	    rel = 0;
	    if (labelsearch(0, block, 1, &rel))
		goto error;
	    goto compile_word;
	case block_end:
	    goto end;
	default:
	    assert(0);
	}
      compile_field:
	compile_int(2, rel);
	continue;
      compile_word:
	compile_int(4, rel);
	continue;
    }
  end:
    return 0;
  error:
    return 1;
}
static void dump(void)
{
    size_t i, pos = 1;
    while (1) {
	cell *block = &mem[pos];
	if (block_end == block[0].size)
	    break;
	fprintf(stderr, "%u[%u,%u,%u,%u]", pos, block[0].size,
		block[1].size, block[2].size, block[3].size);
	for (i = 0; i < block[3].size; i++)
	    fprintf(stderr, " %02hhx", block[4].image[i]);
	fputc('\n', stderr);
	pos = block[2].size;
    }
}
int main(void)
{
    int rst_read, rst_write;
    rst_read = parse_src();
    dump();
    rst_write = compile();
    return rst_read << 1 | rst_write;
}
