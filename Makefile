YACC=bison -y
LEX=flex
CFLAGS=-g -pipe -W -Wall -Werror #-ansi -pedantic
LDFLAGS=-g -pipe -W -Wall -Werror #-ansi -pedantic
LD=$(CC)

PROGS= \
	lexdbg \
	tc \
	RTS.o

TC_SRC = \
	scan.c \
	y.tab.c \
	ast.c \
	mtrack.c \
	literal.c \
	type.c \
	class.c \
	error.c \
	list.c \
	analyze.c \
	conversion.c \
	symtab.c \
	codegen.c \
	main.c

all: $(PROGS)

lexdbg: scan.do literal.o
	$(LD) $(LDFLAGS) scan.do literal.o -o lexdbg -lfl

tc: $(TC_SRC:.c=.o)
	$(LD) $(LDFLAGS) $(TC_SRC:.c=.o) -o tc -lfl

scan.o: scan.c
scan.do: scan.c
scan.c: scan.l y.tab.h
	$(LEX) scan.l
	mv lex.yy.c scan.c

y.tab.h: y.tab.c
y.tab.c: parse.y
	$(YACC) -d parse.y

y.output: parse.y
	$(YACC) -d -v parse.y

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

%.do: %.c
	$(CC) $(CFLAGS) -DDEBUG -c $< -o $@

depend: scan.c y.tab.c
	makedepend *.c

clean:
	rm -f scan.c y.tab.h y.tab.c
	rm -f $(PROGS)
	rm -f *.o *.do
	rm -f Makefile.bak

.PHONY: clean depend
# DO NOT DELETE
