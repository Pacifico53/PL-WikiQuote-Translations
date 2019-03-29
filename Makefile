program:
	flex filter.l
	gcc -o f lex.yy.c

clean:
	rm -f *.html f lex.yy.c
