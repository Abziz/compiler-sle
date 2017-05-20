all:
	$(MAKE) lps
	$(MAKE) lex
	gcc analyzer/lps.tab.c analyzer/lex.yy.c  analyzer/main.c -o lps
lps:
	bison -d analyzer/lps.y
	mv lps.tab.* analyzer/

lex:
	flex analyzer/sle_la.l
	mv lex.yy.c analyzer/
run:
	echo `./lps SLEsample_bad.sle `
	
