all:
	$(MAKE) lps
	$(MAKE) flex
	gcc  compiler/lps.tab.* compiler/lex.yy.c compiler/main.c  -o si
lps:
	bison -d  lps.y
	mv lps.tab.* compiler/
flex:
	flex sle.l
	mv lex.yy.c compiler/
run:
	./si SLEsample_bad.sle
clean:
	rm compiler/lex.yy.c
	rm compiler/lps.tab.*
	rm si.exe
	rm *.lst
