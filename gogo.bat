bison -d  lps.y
mv lps_tab.* compiler/
flex sle.l
mv lex.yy.c compiler/
gcc   compiler/lps_tab.c compiler/lex.yy.c compiler/main.c  -o si
