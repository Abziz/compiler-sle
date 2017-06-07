all:
	$(MAKE) lps
	$(MAKE) lex
	gcc compiler/lps.tab.c compiler/lex.yy.c compiler/main.c  -o si
lps:
	bison -d lps.y
	mv lps.tab.* compiler/
lex:
	flex sle.l
	mv lex.yy.c compiler/
run:
	echo `./si SLEsample_bad.sle `
clean:
	rm compiler/lex.yy.c
	rm compiler/lps.tab.*
	rm si.exe
